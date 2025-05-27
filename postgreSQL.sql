import psycopg2
def create_db(conn):
    cur.execute("""
        CREATE TABLE IF NOT EXISTS clients(
            id SERIAL PRIMARY KEY,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            email TEXT NOT NULL
        );
        CREATE TABLE IF NOT EXISTS phones(
            id SERIAL PRIMARY KEY,
            client_id INTEGER REFERENCES clients(id) ON DELETE CASCADE,
            phone VARCHAR
);        
        """)
    conn.commit() 


def add_client(conn, first_name, last_name, email, phones=None):
    cur.execute("""
        INSERT INTO clients(first_name, last_name, email) VALUES(%s, %s, %s) RETURNING id;
        """, (first_name, last_name, email))
    print(cur.fetchone())  # запрос данных автоматически зафиксирует изменения

def add_phone(conn, client_id, phone):
    cur.execute("""
        INSERT INTO phones(phone, client_id) VALUES(%s, %s) RETURNING id;
        """, (phone, client_id))
    print(cur.fetchone())  # запрос данных автоматически зафиксирует изменения

def change_client(conn, client_id, first_name=None, last_name=None, email=None, phone=None):
    cur.execute("""
        UPDATE phones SET phone=%s WHERE id=%s RETURNING id;
        """, (phone, client_id))
    print(cur.fetchone())
    cur.execute("""
        UPDATE clients SET first_name = %s, last_name =%s, email=%s WHERE id=%s RETURNING id;;
        """, (first_name, last_name, email, client_id))
    print(cur.fetchone())

def delete_phone(conn, client_id, phone):
    cur.execute("""
        DELETE FROM phones WHERE client_id=%s AND phone=%s;
                """,(client_id, phone))

def delete_client(conn, client_id):
    cur.execute("""
        DELETE FROM phones WHERE client_id=%s;
                """,(client_id))
    cur.execute("""
        DELETE FROM clients WHERE id=%s;
                """,(client_id))

def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    cur.execute("""
        SELECT first_name, last_name, email, phone FROM clients cl  
                LEFT JOIN phones ph ON ph.client_id = cl.id
                WHERE cl.first_name=%s and cl.last_name=%s and (cl.email=%s or ph.phone =%s);
                """,(first_name, last_name, email, phone))
    print(cur.fetchone())


with psycopg2.connect(database="postgres", user="get", password="") as conn:
    with conn.cursor() as cur:
        cur.execute("""
        DROP TABLE phones;
        DROP TABLE clients;
        """)
        create_table = create_db(conn)
        client_1 = add_client(conn, 'Ваня', 'Иванов','123@mail.ru')
        new_phone = add_phone(conn, 1, 281289)
        new_phone = add_phone(conn, 1, 28123389)
        client_1_change = change_client(conn, 1, 'Петя', 'Петров', '12223@mail.ru', '28123321222')
        delete_phone_1 = delete_phone(conn, 1, '28123321222')
        delete_client_1 = delete_client(conn, '1')
        finding_client_1 = find_client(conn, 'Петя', 'Петров', None, '28123321222')

conn.close
