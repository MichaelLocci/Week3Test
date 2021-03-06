USE [master]
GO
/****** Object:  Database [Pizzeria]    Script Date: 9/24/2021 3:19:23 PM ******/
CREATE DATABASE [Pizzeria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Pizzeria', FILENAME = N'C:\Users\michael.locci\Pizzeria.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Pizzeria_log', FILENAME = N'C:\Users\michael.locci\Pizzeria_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Pizzeria] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Pizzeria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Pizzeria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Pizzeria] SET ARITHABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Pizzeria] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Pizzeria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Pizzeria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Pizzeria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Pizzeria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Pizzeria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Pizzeria] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Pizzeria] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Pizzeria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Pizzeria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Pizzeria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Pizzeria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Pizzeria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Pizzeria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Pizzeria] SET  MULTI_USER 
GO
ALTER DATABASE [Pizzeria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Pizzeria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Pizzeria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Pizzeria] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Pizzeria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Pizzeria] SET QUERY_STORE = OFF
GO
USE [Pizzeria]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [Pizzeria]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcoloNumeroPizzeConIngrediente]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcoloNumeroPizzeConIngrediente](@nomeIngrediente varchar(40))
returns int
as
begin
declare @numeropizze int

select @numeropizze = count(p.IDPizza)
from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
			join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
where i.NomeIngrediente = @nomeIngrediente

return @numeropizze
end
GO
/****** Object:  UserDefinedFunction [dbo].[CalcoloNumeroPizzeSenzaIngrediente]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[CalcoloNumeroPizzeSenzaIngrediente](@IDIngrediente int)
returns int
as
begin
declare @numeropizze int

select @numeropizze = count(distinct p.IDPizza)
from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
			join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
where  p.IDPizza not in(select p.IDPizza
						from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
									join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
						where i.IDIngrediente=@IDIngrediente)
return @numeropizze
end
GO
/****** Object:  UserDefinedFunction [dbo].[NumeroIngredientiPizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[NumeroIngredientiPizza](@nomePizza varchar(30))
returns int 
as
begin
declare @numeroingredienti int

select @numeroingredienti = count(pin.IDIngrediente) 
from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
			join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
where p.NomePizza = @nomePizza

return @numeroingredienti
end
GO
/****** Object:  Table [dbo].[Pizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pizza](
	[IDPizza] [int] IDENTITY(1,1) NOT NULL,
	[NomePizza] [varchar](30) NOT NULL,
	[PrezzoPizza] [decimal](4, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IDPizza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeOrdinatoPerNome]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeOrdinatoPerNome]()
returns Table
as 
return 
select p.NomePizza as [Nome Pizza], p.PrezzoPizza as [Prezzo Pizza] 
from Pizza p
GO
/****** Object:  Table [dbo].[Ingrediente]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ingrediente](
	[IDIngrediente] [int] IDENTITY(1,1) NOT NULL,
	[NomeIngrediente] [varchar](40) NOT NULL,
	[CostoIngrediente] [decimal](4, 2) NOT NULL,
	[ScorteMagazzino] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IDIngrediente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PizzaIngrediente]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PizzaIngrediente](
	[IDPizza] [int] NOT NULL,
	[IDIngrediente] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeConIngrediente]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeConIngrediente](@nomeIngrediente varchar(40))
returns Table
as
return
select p.NomePizza as [Nome Pizza], p.PrezzoPizza as [Prezzo Pizza] 
from  Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
			join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
where i.NomeIngrediente=@nomeIngrediente
GO
/****** Object:  View [dbo].[Menu]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Menu]([Nome Pizza], [Prezzo Pizza], [Nome Ingrediente])
as(
select p.NomePizza, p.PrezzoPizza, i.NomeIngrediente
from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
			join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
);
GO
/****** Object:  UserDefinedFunction [dbo].[IngredientiPizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[IngredientiPizza](@nomePizza varchar(30))
returns table
as
return
select i.NomeIngrediente
from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
			join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
where p.NomePizza =  @nomePizza
GO
/****** Object:  UserDefinedFunction [dbo].[ListinoPizzeSenzaIngrediente]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[ListinoPizzeSenzaIngrediente](@nomeIngrediente varchar(40))
returns Table
as
return
select distinct p.NomePizza as[Nome Pizza], p.PrezzoPizza as [Prezzo PIzza]
from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
			join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
where  p.IDPizza not in(select p.IDPizza
						from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
									join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
						where i.NomeIngrediente = @nomeIngrediente)
GO
SET IDENTITY_INSERT [dbo].[Ingrediente] ON 

INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (1, N'pomodoro', CAST(2.00 AS Decimal(4, 2)), 100)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (2, N'mozzarella', CAST(1.50 AS Decimal(4, 2)), 200)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (3, N'mozzarella di bufala', CAST(3.00 AS Decimal(4, 2)), 20)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (4, N'spianata piccante', CAST(1.00 AS Decimal(4, 2)), 30)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (6, N'funghi', CAST(0.80 AS Decimal(4, 2)), 40)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (7, N'carciofi', CAST(0.50 AS Decimal(4, 2)), 20)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (8, N'cotto', CAST(1.80 AS Decimal(4, 2)), 10)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (9, N'olive', CAST(4.00 AS Decimal(4, 2)), 0)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (10, N'funghi porcini', CAST(5.00 AS Decimal(4, 2)), 10)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (11, N'stracchino', CAST(2.00 AS Decimal(4, 2)), 15)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (12, N'speck', CAST(3.50 AS Decimal(4, 2)), 30)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (13, N'rucola', CAST(0.90 AS Decimal(4, 2)), 25)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (14, N'grana', CAST(5.00 AS Decimal(4, 2)), 20)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (15, N'verdure di stagione', CAST(2.00 AS Decimal(4, 2)), 36)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (16, N'patate', CAST(2.00 AS Decimal(4, 2)), 50)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (17, N'salsiccia', CAST(4.00 AS Decimal(4, 2)), 32)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (18, N'pomodorini', CAST(4.00 AS Decimal(4, 2)), 10)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (19, N'ricotta', CAST(1.80 AS Decimal(4, 2)), 30)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (20, N'provola', CAST(4.00 AS Decimal(4, 2)), 0)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (21, N'gorgonzola', CAST(6.00 AS Decimal(4, 2)), 10)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (22, N'pomodoro fresco', CAST(3.50 AS Decimal(4, 2)), 5)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (23, N'basilico', CAST(0.60 AS Decimal(4, 2)), 40)
INSERT [dbo].[Ingrediente] ([IDIngrediente], [NomeIngrediente], [CostoIngrediente], [ScorteMagazzino]) VALUES (24, N'bresaola', CAST(6.00 AS Decimal(4, 2)), 10)
SET IDENTITY_INSERT [dbo].[Ingrediente] OFF
GO
SET IDENTITY_INSERT [dbo].[Pizza] ON 

INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (1, N'Margherita', CAST(5.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (2, N'Bufala', CAST(7.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (3, N'Diavola', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (4, N'Quattro Stagioni', CAST(6.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (5, N'Porcini', CAST(7.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (6, N'Dioniso', CAST(8.80 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (7, N'Ortolana', CAST(8.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (8, N'Patate e Salsiccia', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (9, N'Pomodorini', CAST(6.00 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (10, N'Quattro Formaggi', CAST(7.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (11, N'Caprese', CAST(7.50 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (12, N'Zeus', CAST(8.25 AS Decimal(4, 2)))
INSERT [dbo].[Pizza] ([IDPizza], [NomePizza], [PrezzoPizza]) VALUES (13, N'Boscaiola', CAST(6.50 AS Decimal(4, 2)))
SET IDENTITY_INSERT [dbo].[Pizza] OFF
GO
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (1, 1)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (1, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (2, 1)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (2, 3)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (3, 1)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (3, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (3, 4)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (4, 1)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (4, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (4, 6)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (4, 7)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (4, 8)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (4, 9)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (5, 1)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (5, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (5, 10)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (6, 1)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (6, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (6, 11)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (6, 12)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (6, 13)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (6, 14)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (7, 1)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (7, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (7, 15)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (8, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (8, 16)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (8, 17)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (9, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (9, 18)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (9, 19)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (10, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (10, 20)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (10, 21)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (10, 14)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (11, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (11, 22)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (11, 23)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (12, 2)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (12, 24)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (12, 13)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (13, 17)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (13, 6)
INSERT [dbo].[PizzaIngrediente] ([IDPizza], [IDIngrediente]) VALUES (13, 2)
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_PIZINGRE_INGREDIENTE] FOREIGN KEY([IDIngrediente])
REFERENCES [dbo].[Ingrediente] ([IDIngrediente])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_PIZINGRE_INGREDIENTE]
GO
ALTER TABLE [dbo].[PizzaIngrediente]  WITH CHECK ADD  CONSTRAINT [FK_PIZINGRE_PIZZA] FOREIGN KEY([IDPizza])
REFERENCES [dbo].[Pizza] ([IDPizza])
GO
ALTER TABLE [dbo].[PizzaIngrediente] CHECK CONSTRAINT [FK_PIZINGRE_PIZZA]
GO
/****** Object:  StoredProcedure [dbo].[AggiornamentoPrezzoPizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AggiornamentoPrezzoPizza]
@nomePizza varchar(30),
@nuovoPrezzoPizza decimal(4,2)
AS
begin
	begin try
		update Pizza set PrezzoPizza = @nuovoPrezzoPizza where NomePizza = @nomePizza;
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[EliminazioneIngredienteDaPizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[EliminazioneIngredienteDaPizza]
@nomePizza varchar(30),
@nomeIngrediente varchar(40)
AS
begin
	begin try
		delete PizzaIngrediente  where IDPizza = (select p.IDPizza from Pizza p where p.NomePizza=@nomePizza) and
										IDIngrediente = (select i.IDIngrediente from Ingrediente i where i.NomeIngrediente=@nomeIngrediente)
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[IncrementoPrezzoPizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[IncrementoPrezzoPizza] 
@nomeIngrediente varchar(40)
AS
begin
	begin try
		update Pizza
		set PrezzoPizza = PrezzoPizza *1.1
		where IDPizza in(select p.IDPizza
							from Pizza p join PizzaIngrediente pin on p.IDPizza=pin.IDPizza
										join Ingrediente i on i.IDIngrediente=pin.IDIngrediente
							where i.NomeIngrediente =  @nomeIngrediente)
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[InserisciIngredienteInPizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciIngredienteInPizza]
@nomePizza varchar(30),
@nomeIngrediente varchar(40)
As
begin
	begin try
		insert into PizzaIngrediente values((select p.IDPizza from Pizza p where p.NomePizza=@nomePizza),
											(select i.IDIngrediente from Ingrediente i where i.NomeIngrediente=@nomeIngrediente))
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[InserisciPizza]    Script Date: 9/24/2021 3:19:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[InserisciPizza]
@nomePizza varchar(30),
@prezzoPizza decimal (4,2)
As
insert into Pizza(NomePizza,PrezzoPizza)
values(@nomePizza, @prezzoPizza)
GO
USE [master]
GO
ALTER DATABASE [Pizzeria] SET  READ_WRITE 
GO
