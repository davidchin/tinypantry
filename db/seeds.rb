# Default Roles
admin_role = Role.create(name: 'SuperAdmin')

# Default users
admin = User.create(email: 'tinypantry.com@gmail.com', password: 'password', roles: [admin_role])
