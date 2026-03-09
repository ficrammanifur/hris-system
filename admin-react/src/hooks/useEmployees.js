import { useState, useEffect } from 'react'
import employeesService from '../services/employees.service.js'
import toast from 'react-hot-toast'

export const useEmployees = () => {
  const [employees, setEmployees] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetchEmployees()
  }, [])

  const fetchEmployees = async () => {
    try {
      setLoading(true)
      const response = await employeesService.getAll()
      setEmployees(response.data)
      setError(null)
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to fetch employees')
      toast.error('Failed to fetch employees')
    } finally {
      setLoading(false)
    }
  }

  const getEmployee = async (id) => {
    try {
      const response = await employeesService.getById(id)
      return response.data
    } catch (err) {
      toast.error('Failed to fetch employee details')
      throw err
    }
  }

  const createEmployee = async (data) => {
    try {
      const response = await employeesService.create(data)
      setEmployees(prev => [...prev, response.data])
      toast.success('Employee created successfully')
      return response.data
    } catch (err) {
      toast.error(err.response?.data?.message || 'Failed to create employee')
      throw err
    }
  }

  const updateEmployee = async (id, data) => {
    try {
      const response = await employeesService.update(id, data)
      setEmployees(prev => prev.map(emp => emp.id === id ? response.data : emp))
      toast.success('Employee updated successfully')
      return response.data
    } catch (err) {
      toast.error(err.response?.data?.message || 'Failed to update employee')
      throw err
    }
  }

  const deleteEmployee = async (id) => {
    try {
      await employeesService.delete(id)
      setEmployees(prev => prev.filter(emp => emp.id !== id))
      toast.success('Employee deleted successfully')
    } catch (err) {
      toast.error(err.response?.data?.message || 'Failed to delete employee')
      throw err
    }
  }

  return {
    employees,
    loading,
    error,
    getEmployee,
    createEmployee,
    updateEmployee,
    deleteEmployee,
    refresh: fetchEmployees
  }
}