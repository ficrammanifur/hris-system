import { useState } from 'react'
import { Download } from 'lucide-react'
import leavesService from '../../services/leaves.service.js'
import employeesService from '../../services/employees.service.js'
import toast from 'react-hot-toast'

const LeaveReport = () => {
  const [loading, setLoading] = useState(false)

  const generateReport = async () => {
    setLoading(true)
    try {
      const employees = await employeesService.getAll()
      const reportData = []

      for (const employee of employees.data) {
        const leaves = await leavesService.getAll({ user_id: employee.id })
        const balance = await leavesService.getBalance(employee.id)
        
        reportData.push({
          employee: employee.name,
          employee_id: employee.employee_id,
          department: employee.department?.name,
          total_leaves: leaves.data.length,
          pending: leaves.data.filter(l => l.status === 'pending').length,
          approved: leaves.data.filter(l => l.status === 'approved').length,
          rejected: leaves.data.filter(l => l.status === 'rejected').length,
          balance: balance.data.remaining
        })
      }

      // Convert to CSV
      const csv = [
        ['Employee', 'Employee ID', 'Department', 'Total Leaves', 'Pending', 'Approved', 'Rejected', 'Remaining Balance'],
        ...reportData.map(r => [
          r.employee,
          r.employee_id,
          r.department,
          r.total_leaves,
          r.pending,
          r.approved,
          r.rejected,
          r.balance
        ])
      ].map(row => row.join(',')).join('\n')

      // Download CSV
      const blob = new Blob([csv], { type: 'text/csv' })
      const url = window.URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = `leave-report-${new Date().toISOString().split('T')[0]}.csv`
      a.click()
      window.URL.revokeObjectURL(url)

      toast.success('Report generated successfully')
    } catch (error) {
      toast.error('Failed to generate report')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Leave Report</h1>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="flex justify-center">
          <button
            onClick={generateReport}
            disabled={loading}
            className="bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 disabled:opacity-50 flex items-center gap-2"
          >
            <Download className="h-5 w-5" />
            {loading ? 'Generating Report...' : 'Download Leave Report'}
          </button>
        </div>
      </div>
    </div>
  )
}

export default LeaveReport