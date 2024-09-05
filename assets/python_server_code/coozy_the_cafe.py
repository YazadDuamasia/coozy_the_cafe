from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_restx import Api, Resource, fields, Namespace
import psycopg2
from psycopg2 import sql
import uuid
from datetime import datetime, timezone

app = Flask(__name__)
api = Api(app, version='1.0', title='Coozy The Cafe API',
          description='Backend API for Coozy The Cafe using Flask and PostgreSQL')

# Database configuration


def create_db_if_not_exists():
    try:
        # Connection details for the default 'postgres' database
        connection = psycopg2.connect(
            dbname="postgres",  # Connecting to the default database to create a new one
            user="yazad",
            password="147852369+-*",
            host="localhost",
            port="5432"
        )
        connection.autocommit = True  # Enable autocommit mode
        cursor = connection.cursor()

        # Check if the 'coozy_the_cafe' database exists
        cursor.execute(
            "SELECT 1 FROM pg_database WHERE datname = 'coozy_the_cafe'")
        exists = cursor.fetchone()

        if not exists:
            # If the database does not exist, create it
            cursor.execute(sql.SQL("CREATE DATABASE {}").format(
                sql.Identifier("coozy_the_cafe")
            ))
            print("Database 'coozy_the_cafe' created successfully.")
        else:
            print("Database 'coozy_the_cafe' already exists.")

    except Exception as error:
        print("Error while connecting to PostgreSQL:", error)

    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()


# Call the function to ensure the database exists
create_db_if_not_exists()

# Now configure SQLAlchemy to use the 'coozy_the_cafe' database
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql+psycopg2://yazad:147852369+-*@localhost:5432/coozy_the_cafe'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define models


class Employee(db.Model):
    __tablename__ = 'employees'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hashID = db.Column(db.String(36), unique=True,
                       default=lambda: str(uuid.uuid4()))
    name = db.Column(db.String, nullable=False)
    creationDate = db.Column(db.DateTime, nullable=False,
                             default=datetime.now(timezone.utc))
    modificationDate = db.Column(db.DateTime, nullable=True, default=datetime.now(
        timezone.utc), onupdate=datetime.now(timezone.utc))
    phoneNumber = db.Column(db.String, nullable=False)
    position = db.Column(db.String, nullable=False)
    joiningDate = db.Column(db.DateTime, nullable=False)
    leavingDate = db.Column(db.DateTime, nullable=True)
    startWorkingTime = db.Column(db.String, nullable=True)
    endWorkingTime = db.Column(db.String, nullable=True)
    workingHours = db.Column(db.String, nullable=True)
    isDeleted = db.Column(db.Boolean, default=False)

    def to_dict(self):
        def format_datetime(dt, date_only=False):
            if dt is not None:
                if date_only:
                    return dt.strftime('%d-%m-%Y')
                return dt.isoformat() + 'Z'
            return None

        return {
            'hashID': self.hashID,
            'name': self.name,
            'phoneNumber': self.phoneNumber,
            'position': self.position,
            'creationDate': format_datetime(self.creationDate),
            'modificationDate': format_datetime(self.modificationDate),
            'joiningDate': format_datetime(self.joiningDate, date_only=True),
            'leavingDate': format_datetime(self.leavingDate, date_only=True),
            'startWorkingTime': self.startWorkingTime,
            'endWorkingTime': self.endWorkingTime,
            'workingHours': self.workingHours,
            'isDeleted': self.isDeleted
        }


class Attendance(db.Model):
    __tablename__ = 'attendance'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hashID = db.Column(db.String(36), unique=True,
                       default=lambda: str(uuid.uuid4()))
    employeeId = db.Column(db.String(36), db.ForeignKey(
        'employees.hashID'), nullable=False)
    currentStatus = db.Column(db.Integer, nullable=False)
    creationDate = db.Column(db.DateTime, nullable=False,
                             default=datetime.now(timezone.utc))
    modificationDate = db.Column(db.DateTime, nullable=False, default=datetime.now(
        timezone.utc), onupdate=datetime.now(timezone.utc))
    checkIn = db.Column(db.DateTime)
    checkOut = db.Column(db.DateTime)
    employeeWorkingDurations = db.Column(db.String)
    workingTimeDurations = db.Column(db.String)
    isDeleted = db.Column(db.Boolean, default=False)

    def to_dict(self):
        def format_datetime(dt, date_only=False):
            if dt is not None:
                if date_only:
                    return dt.strftime('%d-%m-%Y')
                return dt.isoformat() + 'Z'
            return None

        return {
            'hashID': self.hashID,
            'employeeId': self.employeeId,
            'currentStatus': self.currentStatus,
            'creationDate': format_datetime(self.creationDate),
            'modificationDate': format_datetime(self.modificationDate),
            'checkIn': format_datetime(self.checkIn) if self.checkIn else None,
            'checkOut': format_datetime(self.checkOut) if self.checkOut else None,
            'employeeWorkingDurations': self.employeeWorkingDurations,
            'workingTimeDurations': self.workingTimeDurations if self.workingTimeDurations else None,
            'isDeleted': self.isDeleted if self.isDeleted else False
        }


class Leave(db.Model):
    __tablename__ = 'leaves'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    hashID = db.Column(db.String(36), unique=True,
                       default=lambda: str(uuid.uuid4()))
    employeeId = db.Column(db.String(36), db.ForeignKey(
        'employees.hashID'), nullable=False)
    currentStatus = db.Column(db.Integer, nullable=False)
    creationDate = db.Column(db.DateTime, nullable=False,
                             default=datetime.now(timezone.utc))
    modificationDate = db.Column(db.DateTime, nullable=False, default=datetime.now(
        timezone.utc), onupdate=datetime.now(timezone.utc))
    startDate = db.Column(db.String, nullable=False)
    endDate = db.Column(db.String, nullable=False)
    reason = db.Column(db.String, nullable=False)
    isDeleted = db.Column(db.Boolean, default=False)

    def to_dict(self):
        def format_datetime(dt, date_only=False):
            if dt is not None:
                if date_only:
                    return dt.strftime('%d-%m-%Y')
                return dt.isoformat() + 'Z'
            return None

        return {
            'hashID': self.hashID,
            'employeeId': self.employeeId,
            'currentStatus': self.currentStatus,
            'creationDate': format_datetime(self.creationDate),
            'modificationDate': format_datetime(self.modificationDate),
            'startDate': self.startDate if self.startDate else None,
            'endDate': self.endDate if self.endDate else None,
            'reason': self.reason if self.reason else None,
            'isDeleted': self.isDeleted if self.isDeleted else False
        }


# Create the tables in the database
with app.app_context():
    db.create_all()

# Define the API namespaces and models for Swagger documentation
# Namespace and Model for Employees
employee_ns = Namespace('employees', description='Employee related operations')

employee_model = employee_ns.model('Employee', {
    'id': fields.Integer(readOnly=False, description='The unique identifier of an employee'),
    'hashID': fields.String(readOnly=False, description='The unique identifier of an employee'),
    'name': fields.String(required=False, description='The name of the employee'),
    'phoneNumber': fields.String(required=False, description='The phone number of the employee'),
    'position': fields.String(required=False, description='The position of the employee'),
    'joiningDate': fields.DateTime(required=False, description='The joining date of the employee'),
    'leavingDate': fields.DateTime(description='The leaving date of the employee'),
    'startWorkingTime': fields.String(description='The start working time of the employee'),
    'endWorkingTime': fields.String(description='The end working time of the employee'),
    'workingHours': fields.String(description='The working hours of the employee'),
    'isDeleted': fields.Boolean(description='Soft delete flag')
})

# Namespace and Model for Attendance
attendance_ns = Namespace(
    'attendance', description='Employee attendance related operations')

attendance_model = attendance_ns.model('Attendance', {
    'id': fields.Integer(readOnly=True, description='The unique identifier of an attendance'),
    'hashID': fields.String(readOnly=True, description='The unique identifier of an attendance record'),
    'employeeId': fields.String(required=True, description='The unique identifier of the employee'),
    'currentStatus': fields.Integer(required=True, description='The current status of attendance'),
    'creationDate': fields.DateTime(required=True, description='The creation date of the attendance record'),
    'modificationDate': fields.DateTime(description='The modification date of the attendance record'),
    'checkIn': fields.DateTime(description='The check-in time'),
    'checkOut': fields.DateTime(description='The check-out time'),
    'employeeWorkingDurations': fields.String(description='Duration of working times'),
    'workingTimeDurations': fields.String(description='Duration of working periods'),
    'isDeleted': fields.Boolean(description='Soft delete flag')
})

# Namespace and Model for Leaves
leave_ns = Namespace('leaves', description='Employee leave related operations')

leave_model = leave_ns.model('Leave', {
    'id': fields.Integer(readOnly=True, description='The unique identifier of an leave'),
    'hashID': fields.String(readOnly=True, description='The unique identifier of a leave record'),
    'employeeId': fields.String(required=True, description='The unique identifier of the employee'),
    'currentStatus': fields.Integer(required=True, description='The current status of leave'),
    'creationDate': fields.DateTime(required=True, description='The creation date of the leave record'),
    'modificationDate': fields.DateTime(description='The modification date of the leave record'),
    'startDate': fields.DateTime(required=True, description='The start date of the leave'),
    'endDate': fields.DateTime(required=True, description='The end date of the leave'),
    'reason': fields.String(required=True, description='The reason for the leave'),
    'isDeleted': fields.Boolean(description='Soft delete flag')
})


# Register namespaces with the API
api.add_namespace(employee_ns, path="/employees")
api.add_namespace(attendance_ns, path="/attendance")
api.add_namespace(leave_ns, path="/leaves")


# Helper function to parse date strings
def parse_date(date_str):
    if not date_str:
        return None
    try:
        return datetime.strptime(date_str, '%Y-%m-%dT%H:%M:%S.%fZ')
    except ValueError:
        return None


def parse_time(time_str):
    try:
        return datetime.strptime(time_str, '%I:%M %p').time()
    except ValueError:
        print("Incorrect time format. Please use 'hh:mm a'")
        return None


def format_time(time_obj):
    return time_obj.strftime('%I:%M %p')


# Define the API resources
# Endpoints
@employee_ns.route('')
class EmployeeList(Resource):
    @employee_ns.doc('get_all_employees')
    @employee_ns.param('pageNo', 'Page number for pagination', type=int, required=False)
    @employee_ns.param('itemsPerPage', 'Number of items per page for pagination', type=int, required=False)
    def get(self):
        """Fetch all employees with optional pagination"""
        try:
            page_no = request.args.get('pageNo', type=int)
            items_per_page = request.args.get('itemsPerPage', type=int)

            # Query to filter employees that are not deleted
            query = Employee.query.filter_by(isDeleted=False)
            total_items = query.count()
            # print("query:", query.all())
            # print("total_items:", total_items)

            if page_no and items_per_page:
                # Handle paginated case
                paginated_result = query.paginate(
                    page=page_no, per_page=items_per_page, error_out=False)

                total_pages = paginated_result.pages
                # Check if the page number is out of range
                if page_no > total_pages:
                    response = {
                        'message': 'Page number out of range.',
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'employees': []
                    }
                else:
                    paginated_employees = paginated_result.items
                    response = {
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'employees': [e.to_dict() for e in paginated_employees]
                    }
            else:
                # Handle non-paginated case
                employees = query.all()
                response = {
                    'totalItems': total_items,
                    'employees': [e.to_dict() for e in employees]

                }
            return jsonify(response)
        except Exception as e:
            # Handle any other errors
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500

    @employee_ns.doc('create_employee')
    @employee_ns.expect(employee_model, validate=True)
    def post(self):
        """Create a new employee"""
        data = request.json
        print("Received data:", data)  # Debug: Print incoming data

        # Validate and parse the input data
        try:
            name = data.get('name')
            phone_number = data.get('phoneNumber')
            position = data.get('position')
            joining_date = parse_date(data.get('joiningDate'))
            leaving_date = parse_date(data.get('leavingDate'))
            start_working_time = data.get('startWorkingTime')
            end_working_time = data.get('endWorkingTime')
            working_hours = data.get('workingHours')
            creation_date = datetime.now(timezone.utc)
            modification_date = datetime.now(timezone.utc)
            is_deleted = data.get('isDeleted', False)

            if not all([name, phone_number, position, joining_date, start_working_time, end_working_time, working_hours]):
                return {'message': 'Required fields are missing or invalid'}, 400

            # Create a new employee record
            new_employee = Employee(
                name=name,
                phoneNumber=phone_number,
                position=position,
                joiningDate=joining_date,
                leavingDate=leaving_date,
                startWorkingTime=start_working_time,
                endWorkingTime=end_working_time,
                workingHours=working_hours,
                creationDate=creation_date,
                modificationDate=modification_date,
                isDeleted=is_deleted
            )

            db.session.add(new_employee)
            db.session.commit()

            return jsonify({'message': "New Employee has been added successfully.", 'employee_info': new_employee.to_dict()})
        except Exception as e:
            db.session.rollback
            return jsonify({'message': str(e)}), 500


@employee_ns.route('/info')
class EmployeeInfoResource(Resource):
    @employee_ns.doc('get_employee')
    @employee_ns.param('hashID', 'Hash ID of the employee to be fetched', type=str, required=True)
    @employee_ns.marshal_with(employee_model)
    def get(self):
        """Fetch an employee by hashID using a query parameter"""
        hash_id = request.args.get('hashID')

        if not hash_id:
            return jsonify({'message': 'hashID is required'}), 400

        employee = Employee.query.filter_by(
            hashID=hash_id, isDeleted=False).first()
        if employee:
            return jsonify(employee.to_dict())
        return jsonify({'message': 'Employee not found'}), 404


@employee_ns.route('/update')
class EmployeeUpdateResource(Resource):
    @employee_ns.doc('update_employee')
    @employee_ns.expect(employee_model, validate=True)
    def post(self):
        """Update an existing employee infomation"""
        data = request.json
        hash_id = data.get('hashID')

        if not hash_id:
            return {'message': 'hashID is required'}, 400

        # Start a database transaction
        try:
            employee = Employee.query.filter_by(hashID=hash_id).first()

            if not employee:
                return jsonify({'message': 'Employee not found'}), 404

            # Update employee fields with new data
            employee.name = data.get('name', employee.name)
            employee.phoneNumber = data.get(
                'phoneNumber', employee.phoneNumber)
            employee.position = data.get('position', employee.position)
            employee.joiningDate = parse_date(
                data.get('joiningDate', employee.joiningDate.strftime('%d-%m-%Y')))
            employee.leavingDate = parse_date(data.get('leavingDate', employee.leavingDate.strftime(
                '%d-%m-%Y')) if employee.leavingDate else None)
            employee.startWorkingTime = data.get(
                'startWorkingTime', employee.startWorkingTime)
            employee.endWorkingTime = data.get(
                'endWorkingTime', employee.endWorkingTime)
            employee.workingHours = data.get(
                'workingHours', employee.workingHours)
            employee.modificationDate = datetime.now(timezone.utc)
            employee.isDeleted = data.get('isDeleted', employee.isDeleted)

            # Commit the transaction
            db.session.commit()
            return jsonify({'message': 'Employee updated successfully', 'employee_info': employee.to_dict()})

        except Exception as e:
            # Rollback the transaction in case of error
            db.session.rollback()
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


delete_request_model = employee_ns.model('DeleteEmployee', {
    'hashID': fields.String(required=True, description='Hash ID of the employee to be deleted')
})


@employee_ns.route('/delete')
class DeleteEmployeeResource(Resource):
    @employee_ns.doc('delete_employee')
    @employee_ns.expect(delete_request_model)
    def post(self):
        """Delete an employee by hashID using POST"""
        data = request.get_json()

        if not data or 'hashID' not in data:
            return jsonify({'message': 'hashID is required'}), 400

        hash_id = data['hashID']
        employee = Employee.query.filter_by(hashID=hash_id).first()

        if not employee:
            return jsonify({'message': 'Employee not found'}), 404

        try:
            # Soft delete the employee
            employee.isDeleted = True
            db.session.commit()
            return jsonify({'message': 'Employee deleted successfully', 'employee_info': employee.to_dict()})
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


@employee_ns.route('/search')
class EmployeeSearch(Resource):
    @employee_ns.doc('search_employees')
    @employee_ns.param('search_query', 'Search keyword for employee fields', required=True)
    @employee_ns.param('pageNo', 'Page number for pagination', type=int, required=False)
    @employee_ns.param('itemsPerPage', 'Number of items per page for pagination', type=int, required=False)
    def get(self):
        """Search employees by a keyword with optional pagination"""
        try:
            # Get the search query and pagination parameters
            search_query = request.args.get('search_query', type=str)
            page_no = request.args.get('pageNo', type=int)
            items_per_page = request.args.get('itemsPerPage', type=int)

            # Base query to filter employees that are not deleted
            query = Employee.query.filter_by(isDeleted=False)

            # Apply search filters if search_query is provided
            if search_query:
                search_pattern = f'%{search_query}%'
                query = query.filter(
                    db.or_(
                        Employee.name.ilike(search_pattern),
                        Employee.position.ilike(search_pattern),
                        Employee.phoneNumber.ilike(search_pattern)
                    )
                )

            total_items = query.count()

            if page_no and items_per_page:
                # Handle paginated case
                paginated_result = query.paginate(
                    page=page_no, per_page=items_per_page, error_out=False)

                total_pages = paginated_result.pages

                # Check if the page number is out of range
                if page_no > total_pages:
                    response = {
                        'message': 'Page number out of range.',
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'employees': []
                    }
                else:
                    paginated_employees = paginated_result.items
                    response = {
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'employees': [emp.to_dict() for emp in paginated_employees]
                    }
            else:
                # Handle non-paginated case
                employees = query.all()
                response = {
                    'totalItems': total_items,
                    'employees': [emp.to_dict() for emp in employees]
                }

            return jsonify(response)
        except Exception as e:
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500

# Attendance endpoints


@attendance_ns.route('')
class EmployeeLeeAttenadanceList(Resource):
    @attendance_ns.doc('get_all_employee_attendance')
    @attendance_ns.param('pageNo', 'Page number for pagination', type=int, required=False)
    @attendance_ns.param('itemsPerPage', 'Number of items per page for pagination', type=int, required=False)
    def get(self):
        """Fetch all employees attendance with optional pagination"""
        try:
            page_no = request.args.get('pageNo', type=int)
            items_per_page = request.args.get('itemsPerPage', type=int)

            # Query to filter employees that are not deleted
            query = Attendance.query.filter_by(isDeleted=False)
            total_items = query.count()
            # print("query:", query.all())
            # print("total_items:", total_items)

            if page_no and items_per_page:
                # Handle paginated case
                paginated_result = query.paginate(
                    page=page_no, per_page=items_per_page, error_out=False)

                total_pages = paginated_result.pages

                # Check if the page number is out of range
                if page_no > total_pages:
                    response = {
                        'message': 'Page number out of range.',
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'attendances': []
                    }
                else:
                    paginated_employees_attendance = paginated_result.items
                    response = {
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'attendances': [attendance.to_dict() for attendance in paginated_employees_attendance]
                    }
            else:
                # Handle non-paginated case
                employees_attendance = query.all()
                response = {
                    'totalItems': total_items,
                    'attendances': [attendance.to_dict() for attendance in employees_attendance]

                }
            return jsonify(response)

        except Exception as e:

            # Handle any other errors
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500

    @attendance_ns.doc('create_attendance')
    @attendance_ns.expect(attendance_model, validate=True)
    @attendance_ns.response(201, 'Attendance successfully created.')
    @attendance_ns.response(400, 'Validation Error')
    @attendance_ns.response(500, 'Internal Server Error')
    def post(self):
        """
        Create a new attendance record
        """
        try:
            data = request.json
            if 'employeeId' not in data or 'currentStatus' not in data:
                attendance_ns.abort(
                    400, "Validation Error: 'employeeId' and 'currentStatus' are required fields.")

            new_attendance = Attendance(
                employeeId=data['employeeId'],
                currentStatus=data['currentStatus'],
                checkIn=data.get('checkIn'),
                checkOut=data.get('checkOut'),
                employeeWorkingDurations=data.get('employeeWorkingDurations'),
                workingTimeDurations=data.get('workingTimeDurations'),
                isDeleted=data.get('isDeleted', False)
            )
            db.session.add(new_attendance)
            db.session.commit()
            return jsonify({'message': "New Employee Attendance has been added successfully.", 'attendance_info': new_attendance.to_dict()})
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': str(e)}), 500


@attendance_ns.route('/info')
class EmployeeAttendanceInfoResource(Resource):
    @attendance_ns.doc('get_employee_attendance')
    @attendance_ns.param('hashID', 'Hash ID of the employee attendance to be fetched', type=str, required=True)
    @attendance_ns.marshal_with(attendance_model)
    def get(self):
        """Fetch an employee by hashID using a query parameter"""
        hash_id = request.args.get('hashID')

        if not hash_id:
            return jsonify({'message': 'hashID is required'}), 400

        attendance = Attendance.query.filter_by(
            hashID=hash_id, isDeleted=False).first()
        if attendance is not None:
            return jsonify(attendance.to_dict())
        return jsonify({'message': 'Leave info not found'})


@attendance_ns.route('/update')
class AttendanceUpdateResource(Resource):
    @attendance_ns.doc('update_leave')
    @attendance_ns.expect(attendance_model, validate=True)
    def post(self):
        """Update an existing attendance record"""
        data = request.json
        hash_id = data.get('hashID')

        if not hash_id:
            return {'message': 'hashID is required'}, 400

        try:
            attendance = Attendance.query.filter_by(hashID=hash_id).first()

            if not attendance:
                return jsonify({'message': 'Leave record not found'}), 404

            # Update leave fields with new data
            attendance.currentStatus = data.get(
                'currentStatus', attendance.currentStatus)
            attendance.checkIn = data.get('checkIn', attendance.checkIn)
            attendance.checkOut = data.get('checkOut', attendance.checkOut)
            attendance.employeeWorkingDurations = data.get(
                'employeeWorkingDurations', attendance.employeeWorkingDurations)
            attendance.workingTimeDurations = data.get(
                'workingTimeDurations', attendance.workingTimeDurations)
            attendance.isDeleted = data.get('isDeleted', attendance.isDeleted)

            # Commit the transaction
            db.session.commit()
            return jsonify({'message': 'Attendance record updated successfully', 'attendances': attendance.to_dict()})

        except Exception as e:
            # Rollback the transaction in case of error
            db.session.rollback()
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


# Define the delete request model for attendance
delete_attendance_request_model = attendance_ns.model('DeleteAttendance', {
    'hashID': fields.String(required=True, description='Hash ID of the attendance to be deleted')
})


@attendance_ns.route('/delete')
class DeleteAttendanceResource(Resource):
    @attendance_ns.doc('delete_attendance')
    @attendance_ns.expect(delete_attendance_request_model)
    def post(self):
        """Delete a attendance by hashID using POST"""
        data = request.get_json()

        if not data or 'hashID' not in data:
            return jsonify({'message': 'hashID is required'}), 400

        hash_id = data['hashID']
        attendance = Attendance.query.filter_by(hashID=hash_id).first()

        if not attendance:
            return jsonify({'message': 'Attendance not found'}), 404

        try:
            # Soft delete the attendance
            attendance.isDeleted = True
            db.session.commit()
            return jsonify({'message': 'Leave deleted successfully', 'attendance_info': attendance.to_dict()})
        except Exception as e:
            db.session.rollback()
            app.logger.error(f"Error deleting attendance: {e}")
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


@attendance_ns.route('/search')
class SearchAttendanceResource(Resource):
    @attendance_ns.doc('search_attendance')
    @attendance_ns.param('search_query', 'Search keyword for employee fields', required=False)
    @attendance_ns.param('pageNo', 'Page number for pagination', type=int, required=False)
    @attendance_ns.param('itemsPerPage', 'Number of items per page for pagination', type=int, required=False)
    def get(self):
        """Search for attendances based on employee details with optional pagination"""
        search_query = request.args.get('search_query', '')
        page_no = request.args.get('pageNo', type=int, default=1)
        items_per_page = request.args.get('itemsPerPage', type=int, default=10)

        try:
            # Step 1: Filter Employee records based on search query
            employee_query = db.session.query(Employee)
            if search_query:
                employee_query = employee_query.filter(
                    (Employee.name.ilike(f"%{search_query}%")) |
                    (Employee.position.ilike(f"%{search_query}%")) |
                    (Employee.phoneNumber.ilike(f"%{search_query}%"))
                )

            filtered_employee_ids = [e.hashID for e in employee_query.all()]

            # Step 2: Filter Attendance records based on filtered employee IDs
            attendance_query = db.session.query(Attendance).filter(
                Attendance.employeeId.in_(filtered_employee_ids))
            total_items = attendance_query.count()

            # Step 3: Handle pagination
            if page_no and items_per_page:
                paginated_attendance_result = attendance_query.paginate(
                    page_no, items_per_page,  error_out=False)

                total_pages = paginated_attendance_result.pages

                # Check if the page number is out of range
                if page_no > total_pages:
                    result = {
                        'message': 'Page number out of range.',
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'attendances': []
                    }
                else:
                    # Step 4: Format the result
                    paginated_attendance_items = paginated_attendance_result.items
                    result = {
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'attendances': [attendance.to_dict() for attendance in paginated_attendance_items]
                    }

            else:
                # Handle non-paginated case
                attendances = attendance_query.all()
                result = {
                    'totalItems': total_items,
                    'attendances': [attendance.to_dict() for attendance in attendances.items]
                }

            return jsonify(result)
        except Exception as e:
            app.logger.error(f"Error in search operation: {e}")
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


# Leaves endpoints

@leave_ns.route('')
class EmployeeLeavesList(Resource):
    @leave_ns.doc('get_all_employee_leaves')
    @leave_ns.param('pageNo', 'Page number for pagination', type=int, required=False)
    @leave_ns.param('itemsPerPage', 'Number of items per page for pagination', type=int, required=False)
    def get(self):
        """Fetch all employees leaves with optional pagination"""
        try:
            page_no = request.args.get('pageNo', type=int)
            items_per_page = request.args.get('itemsPerPage', type=int)

            # Query to filter employees that are not deleted
            query = Leave.query.filter_by(isDeleted=False)
            total_items = query.count()
            # print("query:", query.all())
            # print("total_items:", total_items)

            if page_no and items_per_page:
                # Handle paginated case
                paginated_result = query.paginate(
                    page=page_no, per_page=items_per_page, error_out=False)
                paginated_employees_leaves = paginated_result.items
                total_pages = paginated_result.pages
                # Convert employees to a list of dictionaries
                response = {
                    'pageNo': page_no,
                    'itemsPerPage': items_per_page,
                    'totalPages': total_pages,
                    'totalItems': total_items,
                    'leaves': [leave.to_dict() for leave in paginated_employees_leaves]
                }
            else:
                # Handle non-paginated case
                employees_leaves = query.all()
                response = {
                    'totalItems': total_items,
                    'leaves': [leave.to_dict() for leave in employees_leaves]

                }
            return jsonify(response)

        except Exception as e:
            # Handle any other errors
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500

    @leave_ns.doc('create_leave')
    @leave_ns.expect(leave_model, validate=True)
    def post(self):
        """Create a new leave record"""
        data = request.json
        try:
            new_leave = Leave(
                employeeId=data['employeeId'],
                currentStatus=data['currentStatus'],
                startDate=data['startDate'],
                endDate=data['endDate'],
                reason=data['reason'],
            )
            db.session.add(new_leave)
            db.session.commit()
            return jsonify({'message': "Leave record created successfully.", 'leave': new_leave.to_dict()})
        except Exception as e:
            db.session.rollback()
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


@leave_ns.route('/info')
class EmployeeLeaveInfoResource(Resource):
    @leave_ns.doc('get_employee')
    @leave_ns.param('hashID', 'Hash ID of the employee to be fetched', type=str, required=True)
    @leave_ns.marshal_with(leave_model)
    def get(self):
        """Fetch an employee by hashID using a query parameter"""
        hash_id = request.args.get('hashID')

        if not hash_id:
            return jsonify({'message': 'hashID is required'}), 400

        leave = Leave.query.filter_by(
            hashID=hash_id, isDeleted=False).first()
        if leave is not None:
            return jsonify(leave.to_dict())
        return jsonify({'message': 'Leave info not found'})


@leave_ns.route('/update')
class LeaveUpdateResource(Resource):
    @leave_ns.doc('update_leave')
    @leave_ns.expect(leave_model, validate=True)
    def post(self):
        """Update an existing leave record"""
        data = request.json
        hash_id = data.get('hashID')

        if not hash_id:
            return {'message': 'hashID is required'}, 400

        try:
            leave_record = Leave.query.filter_by(hashID=hash_id).first()

            if not leave_record:
                return jsonify({'message': 'Leave record not found'}), 404

            # Update leave fields with new data
            leave_record.currentStatus = data.get(
                'currentStatus', leave_record.currentStatus)
            leave_record.startDate = data.get(
                'startDate', leave_record.startDate)
            leave_record.endDate = data.get('endDate', leave_record.endDate)
            leave_record.reason = data.get('reason', leave_record.reason)
            leave_record.modificationDate = datetime.now(timezone.utc)
            leave_record.isDeleted = data.get(
                'isDeleted', leave_record.isDeleted)

            # Commit the transaction
            db.session.commit()
            return jsonify({'message': 'Leave record updated successfully', 'leave': leave_record.to_dict()})

        except Exception as e:
            # Rollback the transaction in case of error
            db.session.rollback()
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


# Define the delete request model for Leave
delete_leave_request_model = leave_ns.model('DeleteLeave', {
    'hashID': fields.String(required=True, description='Hash ID of the leave to be deleted')
})


@leave_ns.route('/delete')
class DeleteLeaveResource(Resource):
    @leave_ns.doc('delete_leave')
    @leave_ns.expect(delete_leave_request_model)
    def post(self):
        """Delete a leave by hashID using POST"""
        data = request.get_json()

        if not data or 'hashID' not in data:
            return jsonify({'message': 'hashID is required'}), 400

        hash_id = data['hashID']
        leave = Leave.query.filter_by(hashID=hash_id).first()

        if not leave:
            return jsonify({'message': 'Leave not found'}), 404

        try:
            # Soft delete the leave
            leave.isDeleted = True
            db.session.commit()
            return jsonify({'message': 'Leave deleted successfully', 'leave_info': leave.to_dict()})
        except Exception as e:
            app.logger.error(f"Error deleting leave: {e}")
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


@leave_ns.route('/search')
class SearchLeaveResource(Resource):
    @leave_ns.doc('search_leaves')
    @leave_ns.param('search_query', 'Search keyword for employee fields', required=False)
    @leave_ns.param('pageNo', 'Page number for pagination', type=int, required=False)
    @leave_ns.param('itemsPerPage', 'Number of items per page for pagination', type=int, required=False)
    def get(self):
        """Search for leaves based on employee details with optional pagination"""
        search_query = request.args.get('search_query', '')
        page_no = request.args.get('pageNo', type=int, default=1)
        items_per_page = request.args.get('itemsPerPage', type=int, default=10)

        try:
            # Step 1: Filter Employee records based on search query
            employee_query = db.session.query(Employee)
            if search_query:
                employee_query = employee_query.filter(
                    (Employee.name.ilike(f"%{search_query}%")) |
                    (Employee.position.ilike(f"%{search_query}%")) |
                    (Employee.phoneNumber.ilike(f"%{search_query}%"))
                )

            filtered_employee_ids = [e.hashID for e in employee_query.all()]

            # Step 2: Filter Leave records based on filtered employee IDs
            leave_query = db.session.query(Leave).filter(
                Leave.employeeId.in_(filtered_employee_ids))
            total_items = leave_query.count()

            if page_no and items_per_page:
                paginated_leaves_result = leave_query.paginate(
                    page_no, items_per_page,  error_out=False)

                total_pages = paginated_leaves_result.pages

                # Check if the page number is out of range
                if page_no > total_pages:
                    result = {
                        'message': 'Page number out of range.',
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'leaves': []
                    }
                else:
                    # Step 4: Format the result
                    paginated_leaves_items = paginated_leaves_result.items
                    result = {
                        'pageNo': page_no,
                        'itemsPerPage': items_per_page,
                        'totalPages': total_pages,
                        'totalItems': total_items,
                        'leaves': [leave.to_dict() for leave in paginated_leaves_items]
                    }

            else:
                # Handle non-paginated case
                leaves = leave_query.all()
                result = {
                    'totalItems': total_items,
                    'leaves': [leave.to_dict() for leave in leaves.items]
                }
            return jsonify(result)
        except Exception as e:
            app.logger.error(f"Error in search operation: {e}")
            return jsonify({'message': f"Internal server error: {str(e)}"}), 500


if __name__ == '__main__':
    # Start Flask application
    app.run(debug=True)
