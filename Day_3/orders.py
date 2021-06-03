from robot.libraries.BuiltIn import BuiltIn


class Orders(object):
    builtin_lib: BuiltIn = BuiltIn()

    def get_postgresql_lib(self):
        return  self.builtin_lib.get_library_instance("DB")

    def get_tax_and_orders(self, tax, orderdate):
        sql = """SELECT orders.orderdate, orders.tax, customers.lastname, customers.phone, 
        customers.state FROM bootcamp.orders left join bootcamp.customers 
        on orders.customerid = customers.customerid WHERE orders.tax > %(tax)s and orders.orderdate = %(orderdate)s"""

        params = {"tax": tax, "orderdate": orderdate}
        return self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)


    def get_requests_lib(self):
        return self.builtin_lib.get_library_instance("Req")

    def get_tax_from_rest(self, alias, params, expected_status):
        result = self.get_requests_lib().get_on_session(alias=alias, url='/orders?',
                                                        params=params,
                                                        expected_status=expected_status)
        tax = []
        for i in range(len(result.json())):
            tax.append(result.json()[i]['tax'])
        return tax

