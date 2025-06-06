import sqlalchemy
import os
from sqlalchemy import create_engine
from sqlalchemy import (
    Column, Integer, String, 
    ForeignKey, Date, Numeric
)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy.exc import SQLAlchemyError

Base = declarative_base()

# 1. Издатель (автор)
class Publisher(Base):
    __tablename__ = 'publishers'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)
    
    # У издателя может быть много книг
    books = relationship("Book", back_populates="publisher")

# 2. Книга
class Book(Base):
    __tablename__ = 'books'
    
    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    
    # Связь с издателем
    publisher_id = Column(Integer, ForeignKey('publishers.id'))
    publisher = relationship("Publisher", back_populates="books")
    
    # У книги может быть много продаж
    stock = relationship("Stock", back_populates="books")

class Stock(Base):
    __tablename__ = 'stock'

    id = Column(Integer, primary_key=True)
    count = Column(Integer)

    book_id = Column(Integer, ForeignKey('books.id'))
    books = relationship("Book", back_populates = 'stock')

    sales = relationship("Sale", back_populates='stock')

    shop_id = Column(Integer, ForeignKey('shops.id'))
    shop = relationship("Shop", back_populates='stock')

# 3. Магазин
class Shop(Base):
    __tablename__ = 'shops'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(100), nullable=False)

    stock = relationship("Stock", back_populates="shop")
    
# 4. Продажа
class Sale(Base):
    __tablename__ = 'sales'
    
    id = Column(Integer, primary_key=True)
    price = Column(Numeric(10, 2))  # цена продажи
    count = Column(Integer)       
    date_sale = Column(Date)         # дата продажи
    
    # Связь с магазином
    stock_id = Column(Integer, ForeignKey('stock.id'))
    stock = relationship("Stock", back_populates="sales")


# from models import Base, Publisher, Book, Stock, Shop, Sale

def get_db_connection():
    """Создает подключение к БД на основе переменных окружения"""
    db_type = os.getenv('DB_TYPE', 'postgresql')
    db_user = os.getenv('DB_USER', '')
    db_password = os.getenv('DB_PASSWORD', '')
    db_host = os.getenv('DB_HOST', 'localhost')
    db_port = os.getenv('DB_PORT', '5432')
    db_name = os.getenv('DB_NAME', '')

    if db_type == 'sqlite':
        return create_engine(f'sqlite:///{db_name}.db')
    
    return create_engine(
        f'{db_type}://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
    )
def print_sales(sales_data, publisher_name):
    """Красивый вывод результатов"""
    if not sales_data:
        print(f"\nНет данных о продажах книг издателя '{publisher_name}'")
        return
    
    print(f"\nПродажи книг издателя '{publisher_name}':")
    print("=" * 80)
    print(f"{'Книга':<30} | {'Магазин':<20} | {'Цена':<10} | {'Кол-во':<6} | {'Дата':<10}")
    print("-" * 80)
    
    for sale in sales_data:
        print(
            f"{sale.book_title:<30} | {sale.shop_name:<20} | "
            f"{sale.price:<10.2f} | {sale.count:<6} | "
            f"{sale.date_sale.strftime('%d.%m.%Y') if sale.date_sale else 'N/A':<10}"
        )
    print("=" * 80)
    print(f"Всего продаж: {len(sales_data)}")

def main():
    try:
        # 1. Подключение к БД
        engine = get_db_connection()
        Session = sessionmaker(bind=engine)
        session = Session()

        # 2. Запрос данных издателя
        publisher_input = input("Введите имя или ID издателя: ").strip()
        
        # 3. Поиск издателя
        try:
            publisher_id = int(publisher_input)
            publisher = session.query(Publisher).get(publisher_id)
        except ValueError:
            publishers = session.query(Publisher)\
                .filter(Publisher.name.ilike(f"%{publisher_input}%"))\
                .all()
            
            if not publishers:
                print("Издатель не найден!")
                return
            
            if len(publishers) > 1:
                print("\nНайдено несколько издателей:")
                for i, pub in enumerate(publishers, 1):
                    print(f"{i}. {pub.name} (ID: {pub.id})")
                
                choice = input("Выберите номер издателя или 0 для отмены: ")
                try:
                    choice = int(choice)
                    if choice == 0:
                        return
                    publisher = publishers[choice-1]
                except (ValueError, IndexError):
                    print("Неверный выбор!")
                    return
            else:
                publisher = publishers[0]

        # 4. Запрос данных о продажах
        sales_data = session.query(
            Book.title.label("book_title"),
            Shop.name.label("shop_name"),
            Sale.price,
            Sale.count,
            Sale.date_sale
        ).select_from(Publisher)\
         .join(Book, Book.publisher_id == Publisher.id)\
         .join(Stock, Stock.book_id == Book.id)\
         .join(Shop, Shop.id == Stock.shop_id)\
         .join(Sale, Sale.stock_id == Stock.id)\
         .filter(Publisher.id == publisher.id)\
         .order_by(Sale.date_sale.desc())\
         .all()

        # 5. Вывод результатов
        print_sales(sales_data, publisher.name)

    except SQLAlchemyError as e:
        print(f"Ошибка базы данных: {e}")
    except Exception as e:
        print(f"Неожиданная ошибка: {e}")
    finally:
        if 'session' in locals():
            session.close()

if __name__ == "__main__":
    main()
