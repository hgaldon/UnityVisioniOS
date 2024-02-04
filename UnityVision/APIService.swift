import Foundation

class APIService {
    static let baseUrl = "http://3.90.9.35:3000"  // Ensure you're using http:// or https://

    static func signUp(name: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/signup") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["name": name, "email": email, "password": password, "face": 0]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, "JSON serialization error: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Client error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(false, "Server error with status code: \(httpResponse.statusCode)")
                return
            }
            
            if let _ = data {
                completion(true, nil)
            } else {
                completion(false, "No readable data received in response")
            }
        }
        task.resume()
    }

    static func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/login") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["email": email, "password": password]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(false, "JSON serialization error: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Client error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(false, "Server error with status code: \(httpResponse.statusCode)")
                return
            }
            
            if let _ = data {
                completion(true, nil)
            } else {
                completion(false, "No readable data received in response")
            }
        }
        task.resume()
    }
    
    static func uploadFace(_ imageData: Data, completion: @escaping (Bool) -> Void) {
        guard let uploadURL = URL(string: "\(baseUrl)/faceUpload") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(false)
                return
            }

            if let _ = data {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
    
    static func getUsername(email: String, completion: @escaping (Bool, String?) -> Void) {
            guard let url = URL(string: "\(baseUrl)/getUsername") else {
                completion(false, "Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = ["email": email]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(false, "JSON serialization error: \(error.localizedDescription)")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false, "Client error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(false, "Server error")
                    return
                }
                
                if let data = data, let name = String(data: data, encoding: .utf8) {
                    completion(true, name)
                } else {
                    completion(false, "No readable data received in response")
                }
            }
            task.resume()
        }
    
}
