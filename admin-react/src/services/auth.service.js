import api from './api.js'

class AuthService {
  async login(email, password) {
    return api.post('/login', { email, password })
  }

  async logout() {
    return api.post('/logout')
  }

  async getProfile() {
    return api.get('/me')
  }
}

export default new AuthService()