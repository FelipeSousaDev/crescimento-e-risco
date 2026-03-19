CREATE TABLE PEDIDOS (

    id_pedido INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(50) UNIQUE NOT NULL,

    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    -- Definição da Chave Estrangeira (aponta para a tabela Clientes)
    CONSTRAINT FK_PEDIDOS_CLIENTES FOREIGN KEY (customer_id) 
    REFERENCES CLIENTES(customer_id)
);


CREATE TABLE CLIENTES (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)

)

CREATE TABLE PAGAMENTOS (
    id_pagamentos INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR (100),
    payment_installments VARCHAR(100),
    payment_value DECIMAL(10, 2),


    CONSTRAINT FK_PAGAMENTOS_CLIENTES FOREIGN KEY (order_id)
    references PEDIDOS (order_id)

)