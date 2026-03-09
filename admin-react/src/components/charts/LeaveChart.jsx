import { useState, useEffect } from 'react'
import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from 'recharts'
import leavesService from '../../services/leaves.service.js'

const COLORS = ['#3B82F6', '#F59E0B', '#10B981', '#EF4444']

const LeaveChart = () => {
  const [data, setData] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchChartData()
  }, [])

  const fetchChartData = async () => {
    try {
      const response = await leavesService.getAll()
      const leaves = response.data

      const statusCount = {
        pending: leaves.filter(l => l.status === 'pending').length,
        approved: leaves.filter(l => l.status === 'approved').length,
        rejected: leaves.filter(l => l.status === 'rejected').length
      }

      setData([
        { name: 'Pending', value: statusCount.pending },
        { name: 'Approved', value: statusCount.approved },
        { name: 'Rejected', value: statusCount.rejected }
      ])
    } catch (error) {
      console.error('Failed to fetch chart data:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  return (
    <ResponsiveContainer width="100%" height={300}>
      <PieChart>
        <Pie
          data={data}
          cx="50%"
          cy="50%"
          labelLine={false}
          label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
          outerRadius={80}
          fill="#8884d8"
          dataKey="value"
        >
          {data.map((entry, index) => (
            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
          ))}
        </Pie>
        <Tooltip />
        <Legend />
      </PieChart>
    </ResponsiveContainer>
  )
}

export default LeaveChart