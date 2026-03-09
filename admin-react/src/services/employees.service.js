import api from './api.js'

class EmployeesService {
  async getAll() {
    return api.get('/employees')
  }

  async getById(id) {
    return api.get(`/employees/${id}`)
  }

  async create(data) {
    return api.post('/employees', data)
  }

  async update(id, data) {
    return api.put(`/employees/${id}`, data)
  }

  async delete(id) {
    return api.delete(`/employees/${id}`)
  }
}

export default new EmployeesService()