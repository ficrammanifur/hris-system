import { createContext, useState } from 'react'

export const NotificationContext = createContext()

export const NotificationProvider = ({ children }) => {
  const [notifications, setNotifications] = useState([])

  const addNotification = (notification) => {
    setNotifications(prev => [notification, ...prev])
  }

  const removeNotification = (id) => {
    setNotifications(prev => prev.filter(n => n.id !== id))
  }

  const clearNotifications = () => {
    setNotifications([])
  }

  return (
    <NotificationContext.Provider value={{
      notifications,
      addNotification,
      removeNotification,
      clearNotifications
    }}>
      {children}
    </NotificationContext.Provider>
  )
}