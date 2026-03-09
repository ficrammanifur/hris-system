import api from './api.js'

class DepartmentsService {
  async getAll() {
    return api.get('/departments')
  }

  async getById(id) {
    return api.get(`/departments/${id}`)
  }

  async create(data) {
    return api.post('/departments', data)
  }

  async update(id, data) {
    return api.put(`/departments/${id}`, data)
  }

  async delete(id) {
    return api.delete(`/departments/${id}`)
  }
}

export default new DepartmentsService()