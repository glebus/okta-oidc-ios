/*
 * Copyright (c) 2017-Present, Okta, Inc. and/or its affiliates. All rights reserved.
 * The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and limitations under the License.
 */

class RevokeTask: OktaAuthTask<Bool> {

    private let token: String?

    init(token: String?, config: OktaAuthConfig, oktaAPI: OktaHttpApiProtocol) {
        self.token = token
        super.init(config: config, oktaAPI: oktaAPI)
    }

    override func run(callback: @escaping (Bool?, OktaError?) -> Void) {
        guard let revokeEndpoint = getRevokeEndpoint(config) else {
            callback(nil, .noRevocationEndpoint)
            return
        }

        guard let token = token else {
            callback(nil, .noBearerToken)
            return
        }

        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        let data = "token=\(token)&client_id=\(config.clientId)"

        oktaAPI.post(revokeEndpoint, headers: headers, postString: data,
            onSuccess: { response in callback(response?.count == 0 ? true : false , nil)},
            onError: { error in callback(nil, error) })
    }

    func getRevokeEndpoint(_ config: OktaAuthConfig) -> URL? {
        // Get the revocation endpoint from the discovery URL, or build it
        if let revokeEndpoint = OktaAuth.discoveredMetadata?["revocation_endpoint"] {
            return URL(string: revokeEndpoint as! String)
        }

        let issuer = config.issuer
        if issuer.range(of: "oauth2") != nil {
            return URL(string: Utils.removeTrailingSlash(issuer) + "/v1/revoke")
        }
        return URL(string: Utils.removeTrailingSlash(issuer) + "/oauth2/v1/revoke")
    }
}