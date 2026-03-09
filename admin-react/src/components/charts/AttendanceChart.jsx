import { useState, useEffect } from 'react'
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer
} from 'recharts'
import attendanceService from '../../services/attendance.service.js'

const AttendanceChart = () => {
  const [data, setData] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchChartData()
  }, [])

  const fetchChartData = async () => {
    try {
      // Generate last 7 days
      const days = []
      for (let i = 6; i >= 0; i--) {
        const date = new Date()
        date.setDate(date.getDate() - i)
        days.push({
          date: date.toISOString().split('T')[0],
          label: date.toLocaleDateString('en-US', { weekday: 'short' })
        })
      }

      // Fetch attendance for each day
      const chartData = await Promise.all(
        days.map(async (day) => {
          try {
            const response = await attendanceService.getAll({ date: day.date })
            return {
              name: day.label,
              present: response.data.length,
              absent: 10 - response.data.length // Assuming 10 employees
            }
          } catch (error) {
            return {
              name: day.label,
              present: 0,
              absent: 10
            }
          }
        })
      )

      setData(chartData)
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
      <LineChart data={data}>
        <CartesianGrid strokeDasharray="3 3" />
        <XAxis dataKey="name" />
        <YAxis />
        <Tooltip />
        <Legend />
        <Line
          type="monotone"
          dataKey="present"
          stroke="#3B82F6"
          strokeWidth={2}
        />
        <Line
          type="monotone"
          dataKey="absent"
          stroke="#EF4444"
          strokeWidth={2}
        />
      </LineChart>
    </ResponsiveContainer>
  )
}

export default AttendanceChart