import { useEffect, useState } from 'react'
import { Users, CalendarCheck, CalendarClock, Building2 } from 'lucide-react'
import AttendanceChart from '../../components/charts/AttendanceChart.jsx'
import LeaveChart from '../../components/charts/LeaveChart.jsx'
import employeesService from '../../services/employees.service.js'
import attendanceService from '../../services/attendance.service.js'
import leavesService from '../../services/leaves.service.js'
import departmentsService from '../../services/departments.service.js'

const Dashboard = () => {
  const [stats, setStats] = useState({
    totalEmployees: 0,
    totalDepartments: 0,
    todayAttendance: 0,
    pendingLeaves: 0
  })
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDashboardData()
  }, [])

  const fetchDashboardData = async () => {
    try {
      const [employees, departments, attendance, leaves] = await Promise.all([
        employeesService.getAll(),
        departmentsService.getAll(),
        attendanceService.getAll({ date: new Date().toISOString().split('T')[0] }),
        leavesService.getAll({ status: 'pending' })
      ])

      setStats({
        totalEmployees: employees.data.length,
        totalDepartments: departments.data.length,
        todayAttendance: attendance.data.length,
        pendingLeaves: leaves.data.length
      })
    } catch (error) {
      console.error('Failed to fetch dashboard data:', error)
    } finally {
      setLoading(false)
    }
  }

  const statCards = [
    {
      title: 'Total Employees',
      value: stats.totalEmployees,
      icon: Users,
      color: 'bg-blue-500'
    },
    {
      title: 'Departments',
      value: stats.totalDepartments,
      icon: Building2,
      color: 'bg-green-500'
    },
    {
      title: "Today's Attendance",
      value: stats.todayAttendance,
      icon: CalendarCheck,
      color: 'bg-purple-500'
    },
    {
      title: 'Pending Leaves',
      value: stats.pendingLeaves,
      icon: CalendarClock,
      color: 'bg-orange-500'
    }
  ]

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Dashboard</h1>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {statCards.map((stat) => {
          const Icon = stat.icon
          return (
            <div key={stat.title} className="bg-white rounded-lg shadow-sm p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600">{stat.title}</p>
                  <p className="text-2xl font-semibold mt-1">{stat.value}</p>
                </div>
                <div className={`${stat.color} p-3 rounded-lg`}>
                  <Icon className="h-6 w-6 text-white" />
                </div>
              </div>
            </div>
          )
        })}
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h2 className="text-lg font-semibold mb-4">Attendance Overview</h2>
          <AttendanceChart />
        </div>
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h2 className="text-lg font-semibold mb-4">Leave Distribution</h2>
          <LeaveChart />
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-lg font-semibold mb-4">Recent Activity</h2>
        <p className="text-gray-500 text-center py-8">
          No recent activity to display
        </p>
      </div>
    </div>
  )
}

export default Dashboard