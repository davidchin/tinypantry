# Default Roles
admin_role = Role.create(name: 'Admin')

# Default users
User.create(email: 'tinypantry.com@gmail.com', password: 'password', roles: [admin_role])
User.create(email: 'tinypantry.com+user@gmail.com', password: 'password')
