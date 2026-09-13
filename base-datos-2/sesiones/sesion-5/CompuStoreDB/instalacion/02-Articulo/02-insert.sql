-- Tema:        CompuStoreDB - Sesión 5
-- Descripción: Insertar 51 artículos (origen: material de asesoría, adaptado a CompuStore)
-- Autor:       Daniel Hilario

USE CompuStoreDB;

-- Articulos 1-10
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Laptop 15.6" Core i5', 'HP', 14500.00, 1),
       ('Mouse Inalámbrico', 'Logitech', 350.00, 1),
       ('Teclado Mecánico RGB', 'Redragon', 1250.00, 1),
       ('Monitor 24" LED', 'Samsung', 4200.00, 1),
       ('Memoria USB 32GB', 'Kingston', 120.00, 1),
       ('Disco Duro Externo 1TB', 'Seagate', 1500.00, 1),
       ('Silla Gamer', 'Cougar', 5500.00, 1),
       ('Memoria RAM 8GB DDR4', 'Corsair', 700.00, 1),
       ('Tarjeta Gráfica RTX 3060', 'Nvidia', 9800.00, 1),
       ('Mouse Pad Grande RGB', 'Genérico', 300.00, 1);

-- Articulos 11-20
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Cargador Universal para Laptop', 'Genérico', 450.00, 1),
       ('Cámara Web Full HD', 'Logitech', 1100.00, 1),
       ('Audífonos Inalámbricos', 'Sony', 1600.00, 1),
       ('Laptop ThinkPad Core i7', 'Lenovo', 19500.00, 1),
       ('Enfriador de CPU', 'Cooler Master', 600.00, 1),
       ('SSD 240GB', 'Kingston', 800.00, 1),
       ('Impresora Multifuncional', 'HP', 2500.00, 1),
       ('Cable HDMI 2 metros', 'Genérico', 150.00, 1),
       ('Adaptador USB-C a HDMI', 'Genérico', 200.00, 1),
       ('Router WiFi', 'TP-Link', 850.00, 1);

-- Articulos 21-30
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Hub USB 4 puertos', 'Genérico', 220.00, 1),
       ('Smartphone Redmi Note 11', 'Xiaomi', 5900.00, 1),
       ('Lector de Tarjetas SD', 'Genérico', 90.00, 1),
       ('Bocinas Bluetooth', 'JBL', 1300.00, 1),
       ('Cargador Rápido USB-C', 'Genérico', 180.00, 1),
       ('Fuente de Poder 600W', 'EVGA', 1000.00, 1),
       ('Pantalla LED 32" Smart TV', 'LG', 7200.00, 1),
       ('Tarjeta Madre B450', 'ASUS', 2800.00, 1),
       ('Mouse Óptico USB', 'Genérico', 100.00, 1),
       ('Base para Laptop Ajustable', 'Genérico', 350.00, 1);

-- Articulos 31-40
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Tableta Gráfica', 'Wacom', 1900.00, 1),
       ('Memoria RAM 16GB DDR4', 'Kingston', 1400.00, 1),
       ('Disco Duro Interno 2TB', 'WD', 1900.00, 1),
       ('Impresora Láser', 'Brother', 4500.00, 1),
       ('Switch Ethernet 8 puertos', 'Genérico', 650.00, 1),
       ('Cable de Red CAT6 5m', 'Genérico', 80.00, 1),
       ('Auriculares Gamer', 'HyperX', 1800.00, 1),
       ('Ventilador RGB para PC', 'Genérico', 200.00, 1),
       ('Adaptador de Red Inalámbrico USB', 'Genérico', 300.00, 1),
       ('Laptop Aspire 5 Core i3', 'Acer', 9800.00, 1);

-- Articulos 41-51
INSERT INTO Articulo (Nombre, Marca, PrecioUnitario, Activo)
VALUES ('Control Xbox Inalámbrico', 'Microsoft', 1200.00, 1),
       ('Memoria USB 64GB', 'Sandisk', 170.00, 1),
       ('Batería Externa 10000mAh', 'Genérico', 500.00, 1),
       ('Cable USB Tipo-C', 'Genérico', 100.00, 1),
       ('Laptop XPS 13 Core i7', 'Dell', 24000.00, 1),
       ('Soporte de Pared para Monitor', 'Genérico', 400.00, 1),
       ('Toner 85A', 'HP', 800.00, 1),
       ('Teclado Inalámbrico', 'Microsoft', 850.00, 1),
       ('SSD 500GB', 'Samsung', 1600.00, 1),
       ('Repetidor de Señal WiFi', 'Genérico', 300.00, 1),
       ('Estación de Carga USB 6 puertos', 'Genérico', 750.00, 1);
