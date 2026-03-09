import api from './api.js'

class AttendanceService {
  async getAll(params = {}) {
    return api.get('/attendance', { params })
  }

  async checkIn(data) {
    return api.post('/attendance/check-in', data)
  }

  async checkOut(data) {
    return api.post('/attendance/check-out', data)
  }

  async getSummary(userId, month, year) {
    return api.get(`/attendance/summary/${userId}`, { params: { month, year } })
  }
}

export default new AttendanceService()