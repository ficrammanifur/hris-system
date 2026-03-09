import { useState, useEffect } from 'react'
import { Calendar, User, CheckCircle, XCircle, Clock } from 'lucide-react'
import leavesService from '../../services/leaves.service.js'
import employeesService from '../../services/employees.service.js'
import toast from 'react-hot-toast'

const LeaveList = () => {
  const [leaves, setLeaves] = useState([])
  const [employees, setEmployees] = useState([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')

  useEffect(() => {
    fetchEmployees()
  }, [])

  useEffect(() => {
    if (employees.length > 0) {
      fetchLeaves()
    }
  }, [filter, employees])

  const fetchEmployees = async () => {
    try {
      const response = await employeesService.getAll()
      setEmployees(response.data)
    } catch (error) {
      toast.error('Failed to fetch employees')
    }
  }

  const fetchLeaves = async () => {
    setLoading(true)
    try {
      const params = filter !== 'all' ? { status: filter } : {}
      const response = await leavesService.getAll(params)
      setLeaves(response.data)
    } catch (error) {
      toast.error('Failed to fetch leaves')
    } finally {
      setLoading(false)
    }
  }

  const getEmployeeName = (userId) => {
    const employee = employees.find(e => e.id === userId)
    return employee ? employee.name : 'Unknown'
  }

  const getStatusBadge = (status) => {
    const badges = {
      pending: { bg: 'bg-yellow-100', text: 'text-yellow-800', icon: Clock },
      approved: { bg: 'bg-green-100', text: 'text-green-800', icon: CheckCircle },
      rejected: { bg: 'bg-red-100', text: 'text-red-800', icon: XCircle }
    }
    const badge = badges[status] || badges.pending
    const Icon = badge.icon
    return (
      <span className={`${badge.bg} ${badge.text} px-2 py-1 rounded-full text-xs font-medium flex items-center gap-1 w-fit`}>
        <Icon className="h-3 w-3" />
        {status}
      </span>
    )
  }

  const getTypeColor = (type) => {
    const colors = {
      sick: 'bg-purple-100 text-purple-800',
      annual: 'bg-blue-100 text-blue-800',
      unpaid: 'bg-gray-100 text-gray-800',
      other: 'bg-orange-100 text-orange-800'
    }
    return colors[type] || 'bg-gray-100 text-gray-800'
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-semibold text-gray-900">Leave Requests</h1>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-sm p-4">
        <div className="flex gap-4">
          <button
            onClick={() => setFilter('all')}
            className={`px-4 py-2 rounded-lg ${
              filter === 'all'
                ? 'bg-blue-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            All
          </button>
          <button
            onClick={() => setFilter('pending')}
            className={`px-4 py-2 rounded-lg ${
              filter === 'pending'
                ? 'bg-yellow-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Pending
          </button>
          <button
            onClick={() => setFilter('approved')}
            className={`px-4 py-2 rounded-lg ${
              filter === 'approved'
                ? 'bg-green-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Approved
          </button>
          <button
            onClick={() => setFilter('rejected')}
            className={`px-4 py-2 rounded-lg ${
              filter === 'rejected'
                ? 'bg-red-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Rejected
          </button>
        </div>
      </div>

      {/* Leave Cards */}
      {loading ? (
        <div className="flex items-center justify-center h-64">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-6">
          {leaves.map((leave) => (
            <div key={leave.id} className="bg-white rounded-lg shadow-sm p-6">
              <div className="flex items-start justify-between">
                <div className="flex items-start gap-4">
                  <div className="bg-blue-100 p-3 rounded-lg">
                    <Calendar className="h-6 w-6 text-blue-600" />
                  </div>
                  <div>
                    <div className="flex items-center gap-3 mb-2">
                      <h3 className="font-semibold text-gray-900">
                        {getEmployeeName(leave.user_id)}
                      </h3>
                      {getStatusBadge(leave.status)}
                    </div>
                    <div className="flex items-center gap-2 text-sm text-gray-500 mb-2">
                      <User className="h-4 w-4" />
                      <span>{leave.type}</span>
                      <span className="mx-2">•</span>
                      <span>{leave.days} days</span>
                    </div>
                    <p className="text-gray-700 mb-2">{leave.reason}</p>
                    <div className="flex items-center gap-4 text-sm">
                      <span className="text-gray-500">
                        {new Date(leave.start_date).toLocaleDateString()} - {new Date(leave.end_date).toLocaleDateString()}
                      </span>
                    </div>
                    {leave.rejection_reason && (
                      <div className="mt-3 p-3 bg-red-50 rounded-lg">
                        <p className="text-sm text-red-800">
                          <strong>Rejection reason:</strong> {leave.rejection_reason}
                        </p>
                      </div>
                    )}
                  </div>
                </div>
                {leave.status === 'pending' && (
                  <div className="flex gap-2">
                    <button
                      onClick={async () => {
                        try {
                          await leavesService.approve(leave.id)
                          toast.success('Leave approved')
                          fetchLeaves()
                        } catch (error) {
                          toast.error('Failed to approve leave')
                        }
                      }}
                      className="px-3 py-1 bg-green-500 text-white rounded-lg hover:bg-green-600 text-sm"
                    >
                      Approve
                    </button>
                    <button
                      onClick={async () => {
                        const reason = prompt('Enter rejection reason:')
                        if (reason) {
                          try {
                            await leavesService.reject(leave.id, reason)
                            toast.success('Leave rejected')
                            fetchLeaves()
                          } catch (error) {
                            toast.error('Failed to reject leave')
                          }
                        }
                      }}
                      className="px-3 py-1 bg-red-500 text-white rounded-lg hover:bg-red-600 text-sm"
                    >
                      Reject
                    </button>
                  </div>
                )}
              </div>
            </div>
          ))}

          {leaves.length === 0 && (
            <div className="text-center py-12 text-gray-500">
              No leave requests found
            </div>
          )}
        </div>
      )}
    </div>
  )
}

export default LeaveList