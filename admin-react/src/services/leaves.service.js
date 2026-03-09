import api from './api.js'

class LeavesService {
  async getAll(params = {}) {
    return api.get('/leaves', { params })
  }

  async create(data) {
    return api.post('/leaves', data)
  }

  async approve(id) {
    return api.post(`/leaves/${id}/approve`)
  }

  async reject(id, reason) {
    return api.post(`/leaves/${id}/reject`, { rejection_reason: reason })
  }

  async getBalance(userId) {
    return api.get(`/leaves/balance/${userId}`)
  }
}

export default new LeavesService()