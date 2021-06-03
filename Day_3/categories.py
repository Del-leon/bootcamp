from robot.libraries.BuiltIn import BuiltIn


class Categories(object):
    builtin_lib: BuiltIn = BuiltIn()

    def get_postgresql_lib(self):
        return  self.builtin_lib.get_library_instance("DB")

    def get_category_and_categoryname(self, category):
        sql = """SELECT * FROM bootcamp.categories WHERE category > %(category)s"""

        params = {"category": category}
        result = self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)[0]
        return [result['category'], result['categoryname']]


    def get_requests_lib(self):
        return self.builtin_lib.get_library_instance("Req")

    def get_data_from_rest(self, alias, params, expected_status):
        result = self.get_requests_lib().get_on_session(alias=alias, url='/categories?',
                                                        params=params,
                                                        expected_status=expected_status)
        return [result.json()[0]['category'], result.json()[0]['categoryname']]

    def add_new_data(self, category, categoryname):
        data = {"category": category, "categoryname": categoryname}
        self.get_requests_lib().post_on_session(alias='alias',
                                                url='/categories?',
                                                data=data)