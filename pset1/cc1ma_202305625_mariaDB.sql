-- DROP DATABASE IF EXISTS uvv;

--- Criação do BD UVV onde sera armazenado as tabelas do projeto Lojas UVV.

CREATE DATABASE uvv 

    CHARACTER SET = 'UTF8';


--- Criação do usuario jpestevao dono do BD UVV.
CREATE USER jpestevao@localhost;



--- Acesso ao BD UVV
USE uvv;


--- Criação da tabela produtos.

CREATE TABLE Produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome_produtos VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes LONGBLOB,
                imagem LONGBLOB,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                PRIMARY KEY (produto_id)
);

ALTER TABLE Produtos COMMENT 'Esta tabela armazena informações dos produtos disponíveis na loja.';

ALTER TABLE Produtos
add constraint check_preco
CHECK (preco_unitario >= 0);

ALTER TABLE Produtos MODIFY COLUMN produto_id NUMERIC(38) NOT NULL COMMENT 'Identificador do produto (chave primaria)';

ALTER TABLE Produtos MODIFY COLUMN nome_produtos VARCHAR(255) NOT NULL COMMENT 'Nome do produto';

ALTER TABLE Produtos MODIFY COLUMN preco_unitario NUMERIC(10, 2) COMMENT 'Preço unitário do produto';

ALTER TABLE Produtos MODIFY COLUMN detalhes BLOB COMMENT 'Detalhes sobre o produto';

ALTER TABLE Produtos MODIFY COLUMN imagem BLOB COMMENT 'Dados binarios armazenados da imagem';

ALTER TABLE Produtos MODIFY COLUMN imagem_mime_type VARCHAR(512) COMMENT 'Identificador do tipo de midia e formato de dados da imagem';

ALTER TABLE Produtos MODIFY COLUMN imagem_arquivo VARCHAR(512) COMMENT 'Nome do arquivo da imagem';

ALTER TABLE Produtos MODIFY COLUMN imagem_charset VARCHAR(512) COMMENT 'Charset da imagem';

ALTER TABLE Produtos MODIFY COLUMN imagem_ultima_atualizacao DATE COMMENT 'Data e hora da última atualização da imagem';




--- Criação da tabela lojas.
CREATE TABLE Lojas (
                loja_id NUMERIC(38) NOT NULL,
                Nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo LONGBLOB,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                PRIMARY KEY (loja_id)
);

ALTER TABLE Lojas COMMENT 'Esta tabela armazena informações das lojas cadastradas.';

ALTER TABLE Lojas
ADD CONSTRAINT check_enderecos
CHECK ((endereco_fisico IS NOT NULL AND endereco_web IS NULL) OR
       (endereco_fisico IS NULL AND endereco_web IS NOT NULL));


ALTER TABLE Lojas MODIFY COLUMN loja_id NUMERIC(38) NOT NULL COMMENT 'Identificador da loja ( chave primaria)';

ALTER TABLE Lojas MODIFY COLUMN Nome VARCHAR(255) NOT NULL COMMENT 'Nome da loja';

ALTER TABLE Lojas MODIFY COLUMN endereco_web VARCHAR(100) COMMENT 'Endereço web da loja';

ALTER TABLE Lojas MODIFY COLUMN endereco_fisico VARCHAR(512) COMMENT 'Endereço fisico da loja';

ALTER TABLE Lojas MODIFY COLUMN latitude NUMERIC COMMENT 'Localização da latitude da loja';

ALTER TABLE Lojas MODIFY COLUMN longitude NUMERIC COMMENT 'Localização da longitude da loja';

ALTER TABLE Lojas MODIFY COLUMN logo BLOB COMMENT 'Dados binarios armazenados da logo';

ALTER TABLE Lojas MODIFY COLUMN logo_mime_type VARCHAR(512) COMMENT 'Identificador do tipo de midia e formato de dados da logo';

ALTER TABLE Lojas MODIFY COLUMN logo_arquivo VARCHAR(512) COMMENT 'Nome do arquivo do logo';

ALTER TABLE Lojas MODIFY COLUMN logo_charset VARCHAR(512) COMMENT 'Charset do logo';

ALTER TABLE Lojas MODIFY COLUMN logo_ultima_atualizacao DATE COMMENT 'Data da última atualização do logo';



--- Criação da tabela estoques.


CREATE TABLE Estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                PRIMARY KEY (estoque_id)
);

ALTER TABLE Estoques COMMENT 'Esta tabela armazena informações de estoque dos produtos em cada loja.';

ALTER TABLE Estoques
ADD CONSTRAINT check_quantidade_estoques
CHECK (quantidade >= 0);

ALTER TABLE Estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES Lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES Produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


ALTER TABLE Estoques MODIFY COLUMN estoque_id NUMERIC(38) NOT NULL COMMENT 'Identificado do estoque (chave primaria)';

ALTER TABLE Estoques MODIFY COLUMN loja_id NUMERIC(38) NOT NULL COMMENT 'Identificador da loja (chave estrangeira referenciando a tabela lojas)';

ALTER TABLE Estoques MODIFY COLUMN produto_id NUMERIC(38) NOT NULL COMMENT 'Identificador do produto (chave estrangeira referenciando a tabela produtos)';

ALTER TABLE Estoques MODIFY COLUMN quantidade NUMERIC(38) NOT NULL COMMENT 'Quantidade disponível em estoque';





--- Criação da tabela clientes.

CREATE TABLE Clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                PRIMARY KEY (cliente_id)
);

ALTER TABLE Clientes COMMENT 'Esta tabela armazena informações dos clientes da Loja.';

ALTER TABLE Clientes MODIFY COLUMN cliente_id NUMERIC(38) NOT NULL  COMMENT 'Identificador do cliente (chave primária)';

ALTER TABLE Clientes MODIFY COLUMN email VARCHAR(255) NOT NULL COMMENT 'Endereço de e-mail do cliente';

ALTER TABLE Clientes MODIFY COLUMN nome VARCHAR(255) NOT NULL COMMENT 'Nome do cliente';

ALTER TABLE Clientes MODIFY COLUMN telefone1 VARCHAR(20) COMMENT 'Primeiro telefone do cliente';

ALTER TABLE Clientes MODIFY COLUMN telefone2 VARCHAR(20) COMMENT 'Segundo telefone do cliente';

ALTER TABLE Clientes MODIFY COLUMN telefone3 VARCHAR(20) COMMENT 'Terceiro telefone do cliente';


--- Criação da tabela envios.

CREATE TABLE Envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                PRIMARY KEY (envio_id)
);

ALTER TABLE Envios COMMENT 'Esta tabela armazena informações sobre os envios de produtos para os clientes.';

alter table Envios add constraint check_status_envios
check (status in ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

ALTER TABLE Envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES Lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES Clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


ALTER TABLE Envios MODIFY COLUMN envio_id NUMERIC(38) NOT NULL COMMENT 'Identificador do envio ( chave primaria)';

ALTER TABLE Envios MODIFY COLUMN loja_id NUMERIC(38) NOT NULL COMMENT 'Identificador da loja associado a tabela envios (chave estrangeira referenciando a tabela lojas)';

ALTER TABLE Envios MODIFY COLUMN cliente_id NUMERIC(38) NOT NULL COMMENT 'Identificador do cliente associado a tabela envios (chave estrangeira referenciando a tabela clientes)';

ALTER TABLE Envios MODIFY COLUMN endereco_entrega VARCHAR(512) NOT NULL COMMENT 'Endereço de entrega do envio';

ALTER TABLE Envios MODIFY COLUMN status VARCHAR(15) NOT NULL COMMENT 'Status do envio';



--- Criação da tabela pedidos.


CREATE TABLE Pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora DATETIME NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                STATUS VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                PRIMARY KEY (pedido_id)
);

ALTER TABLE Pedidos COMMENT 'Esta tabela armazena informações sobre os pedidos realizados pelos clientes.';

alter table Pedidos add constraint check_status_pedidos
check (status in ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

ALTER TABLE Pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES Clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE Pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES Lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


ALTER TABLE Pedidos MODIFY COLUMN pedido_id NUMERIC(38) NOT NULL COMMENT 'Identificador do pedido (chave primaria)';

ALTER TABLE Pedidos MODIFY COLUMN data_hora TIMESTAMP NOT NULL COMMENT 'Data e hora do pedido';

ALTER TABLE Pedidos MODIFY COLUMN cliente_id NUMERIC(38) NOT NULL COMMENT 'Identificador do cliente associado ao pedido (chave estrangeira referenciando a tabela clientes)';

ALTER TABLE Pedidos MODIFY COLUMN status VARCHAR(15) NOT NULL COMMENT 'Status dos pedidos';

ALTER TABLE Pedidos MODIFY COLUMN loja_id NUMERIC(38) NOT NULL COMMENT 'Identificador da loja onde o pedido foi realizado (chave estrangeira referenciando a tabela lojas)';


--- Criação da tabela pedidos_itens.

CREATE TABLE pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38),
                PRIMARY KEY (produto_id, pedido_id)
);

ALTER TABLE pedidos_itens COMMENT 'Esta tabela armazena os itens de um pedido em uma loja.';

ALTER TABLE pedidos_itens
ADD CONSTRAINT check_quantidade_pedidos_itens
CHECK (quantidade >= 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES Produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES Pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES Envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION;


ALTER TABLE pedidos_itens MODIFY COLUMN pedido_id NUMERIC(38) NOT NULL COMMENT 'Identificador do pedido (chave composta (PK e FK) referenciando a tabela pedidos)';

ALTER TABLE pedidos_itens MODIFY COLUMN produto_id NUMERIC(38) NOT NULL COMMENT 'Identificador do produto (chave composta (PK e FK) referenciando a tabela produtos)';

ALTER TABLE pedidos_itens MODIFY COLUMN numero_da_linha NUMERIC(38) NOT NULL COMMENT 'Número da linha do item no pedido';

ALTER TABLE pedidos_itens MODIFY COLUMN preco_unitario NUMERIC(10, 2) NOT NULL COMMENT 'Preço unitário do produto no momento do pedido';

ALTER TABLE pedidos_itens MODIFY COLUMN Quantidade NUMERIC(38) NOT NULL COMMENT 'Quantidade solicitada do produto';

ALTER TABLE pedidos_itens MODIFY COLUMN envio_id NUMERIC(38) NOT NULL COMMENT 'Identificador do envio (chave estrangeira referenciando a tabela envios)';