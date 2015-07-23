set :environment, "production"

every 1.day, at: '1:00 am' do 
  runner 'Notification.old.delete_all'
end