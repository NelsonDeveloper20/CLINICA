-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-01-2021 a las 17:18:21
-- Versión del servidor: 10.4.17-MariaDB
-- Versión de PHP: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `clinicadb`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Listar_ArchivosTrabajador` (`p_IdTipoDocumentoTrabjador` INT)  BEGIN
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select a.nombreArchivo,a.rutaArchivo,UPPER(RIGHT(a.nombreArchivo, 4)) as tipo
from ArchivoTrabajador a  
where a.idArchivoTrabajador=p_IdTipoDocumentoTrabjador;  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_eliminarArchivoById` (`p_idarchivoDocument` INT)  BEGIN

delete from archivotrabajador where idArchivoTrabajador=p_idarchivoDocument;

select  '0' as msj;  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_exportarDocumentoClinica` (`p_dni` VARCHAR(50), `p_Nombre` VARCHAR(100))  BEGIN

-- SQLINES LICENSE FOR EVALUATION USE ONLY
select tdt.idTipoDocumentoTrabajador,t.NombreCompleto,    td.Descripcion as TipoDocumento,  
    ifnull(a.nombreArchivo,'') as nombreArchivo ,
    ifnull( e.Descripcion ,'Pendiente') as estadovalidacion,
    ifnull(a.ValidacionClinica,'') as ValidacionClinica,
     ifnull(a.Observacion,'') as Observacion
 from TipoDocumentoTrabajador tdt    
 left join ArchivoTrabajador a on  a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador
 left join EstadoValidacion e on e.idEstadoValidacion=a.idEstadoValidacion
left join TipoDocumentos td on td.idTipoDocumentos=tdt.idTipoDocumentos         
left join Trabajador t on t.idTrabajador=tdt.IdTrabajador 
 WHERE t.Dni=p_dni  or t.NombreCompleto =p_Nombre;  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_InsertArchivo` (`p_idTrabajador` INT, `p_idTipoDocumento` INT, `p_idTipoDocumentoTrabajador` INT, `p_rutaArchivo` VARCHAR(1000), `p_nombreArchivo` VARCHAR(1000))  begin  
update TipoDocumentoTrabajador set existe='Si',idEstadoValidacion=5  
where idTipoDocumentos=p_idTipoDocumento and IdTrabajador=p_idTrabajador;  
  
insert into ArchivoTrabajador(idTipoDocumentoTrabajador,rutaArchivo,nombreArchivo)  
values(p_idTipoDocumentoTrabajador,p_rutaArchivo,p_nombreArchivo);  
  
select  '0' as msj;    
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_ListarDocumentosValidados` (`p_idUsuario` INT)  begin    
  

-- SQLINES LICENSE FOR EVALUATION USE ONLY
select (select count(a.idArchivoTrabajador)+1 from ArchivoTrabajador a where 
a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador) as rowsfile,TDT.idTipoDocumentoTrabajador,TDT.IdTrabajador,    
TDT.idTipoDocumentos,td.Descripcion as TipoDocumento,    
ifnull((SELECT CONCAT('[',GROUP_CONCAT('{',
    CONCAT(
	'"idArchivoTrabajador":', '"', a.idArchivoTrabajador  , '"', ','  
    '"Observacion":', '"',ifnull(a.Observacion,'')  ,  '"', ','  
    '"nombreArchivo":', '"',a.nombreArchivo  ,  '"', ','  
    '"Estado":', '"',ifnull((select e.Descripcion from  EstadoValidacion e where e.idEstadoValidacion=a.idEstadoValidacion),'Pendiente') , '"', ','  
    '"ValidacionClinica":', '"',ifnull(a.ValidacionClinica,'Pendiente')  , '"', ','  
    '"idTipoDocumentoTrabajador":', '"',a.idTipoDocumentoTrabajador  , '"')
    
 , '}' SEPARATOR ','), ']') 
	  from   ArchivoTrabajador a    
where a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador),'0') as archivos
 from TipoDocumentoTrabajador tdt    
left join TipoDocumentos td on td.idTipoDocumentos=tdt.idTipoDocumentos    
left join EstadoValidacion e on e.idEstadoValidacion=TDT.idEstadoValidacion 
WHERE tdt.IdTrabajador=p_idUsuario;    
    
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_listarPendientes` (`p_idUsuario` INT)  begin   
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select (select count(a.idArchivoTrabajador)+1 from ArchivoTrabajador a where 
a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador) as rowsfile,TDT.idTipoDocumentoTrabajador,TDT.IdTrabajador,  
TDT.idTipoDocumentos,td.Descripcion as TipoDocumento,  
tdt.existe,    
ifnull((SELECT  GROUP_CONCAT(a.nombreArchivo, ', ')   
FROM ArchivoTrabajador a  
where a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador),'') as archivo, 
ifnull((SELECT CONCAT('[',GROUP_CONCAT('{',
    CONCAT(
	'"idArchivoTrabajador":', '"', ifnull(a.idArchivoTrabajador,'')  , '"', ','  
    '"rutaArchivo":', '"',ifnull(a.rutaArchivo,'')  ,  '"', ','  
    '"nombreArchivo":', '"',ifnull(a.nombreArchivo,'')  ,  '"', ','  
    '"estado":', '"',ifnull(a.ValidacionClinica,'')  ,  '"', ','  
    '"Observacion":', '"',case when ifnull(a.ValidacionClinica,'')!='' then
    ifnull(a.Observacion,'') else 'Clinica validara tá tu(s) documento(s)' end   ,  '"', ','  
    '"tipo":', '"',UPPER(RIGHT(RTRIM(a.nombreArchivo), 4))  , '"', ','  
    '"idTipoDocumentoTrabajador":', '"',a.idTipoDocumentoTrabajador  , '"')
    
 , '}' SEPARATOR ','), ']') 
	  from   ArchivoTrabajador a    
where a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador),'0') as archivos,
 
(case when tdt.existe='No' then ''   
else 'Clinica validara tá tu(s) documento(s)' end )as comentario  
  
from TipoDocumentoTrabajador tdt  
left join TipoDocumentos td on td.idTipoDocumentos=tdt.idTipoDocumentos  
left join EstadoValidacion e on e.idEstadoValidacion=TDT.idEstadoValidacion  
WHERE tdt.IdTrabajador=p_idUsuario;  
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_listarTrabajadores` ()  BEGIN
select t.idtrabajador,t.idPuestoArchivo,t.NombreCompleto,t.Dni,p.Descripcion as puesto from trabajador t
left join puestoarchivo p on p.idPuestoArchivo=t.idPuestoArchivo
where p.Descripcion !='CLINICA';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_ListarValidarClinica` (`p_dni` VARCHAR(50), `p_Nombre` VARCHAR(100))  begin      
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select (select count(a.idArchivoTrabajador)+1 from ArchivoTrabajador a where 
a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador) as rowsfile,t.NombreCompleto, TDT.idTipoDocumentoTrabajador,  td.Descripcion as TipoDocumento,    
ifnull((SELECT CONCAT('[',GROUP_CONCAT('{',
    CONCAT(
	'"idArchivoTrabajador":', '"', a.idArchivoTrabajador  , '"', ','  
    '"Observacion":', '"',ifnull(a.Observacion,'')  ,  '"', ','  
    '"nombreArchivo":', '"',a.nombreArchivo  ,  '"', ','  
    '"Estado":', '"',ifnull((select e.Descripcion from  EstadoValidacion e where e.idEstadoValidacion=a.idEstadoValidacion),'Pendiente') , '"', ','  
    '"ValidacionClinica":', '"',ifnull(a.ValidacionClinica,'0')  , '"', ','  
    '"idTipoDocumentoTrabajador":', '"',a.idTipoDocumentoTrabajador  , '"')
    
 , '}' SEPARATOR ','), ']') 
	  from   ArchivoTrabajador a    
where a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador),'0') as archivos
 from TipoDocumentoTrabajador tdt    
left join TipoDocumentos td on td.idTipoDocumentos=tdt.idTipoDocumentos         
left join Trabajador t on t.idTrabajador=tdt.IdTrabajador 
WHERE t.Dni=p_dni  or t.NombreCompleto =p_Nombre;  
 
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_ListDocumentosFaltantes` (`p_idUsuario` INT, `p_idPerfil` INT, `p_idPuestoArchivo` INT)  begin  
insert TipoDocumentoTrabajador(IdTrabajador,idTipoDocumentos,existe)  
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select p_idUsuario,td.idTipoDocumentos,'No' from TipoDocumentos td  
left join PuestoArchivo pa on pa.idPuestoArchivo=td.idPuestoArchivo  
left join Perfil p on p.idPerfil=pa.idPerfil  
where p.idPerfil=p_idPerfil and pa.idPuestoArchivo=p_idPuestoArchivo  
and td.idTipoDocumentos not in(select t.idTipoDocumentos from TipoDocumentoTrabajador t where t.IdTrabajador=p_idUsuario );  
  
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select  (select count(a.idArchivoTrabajador)+1 from ArchivoTrabajador a where 
a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador) as rowsfile,TDT.idTipoDocumentoTrabajador,TDT.IdTrabajador,  
TDT.idTipoDocumentos,td.Descripcion as TipoDocumento,  
tdt.existe,ifnull(e.Descripcion,'-') as estado,
ifnull((SELECT CONCAT('[',GROUP_CONCAT('{',
    CONCAT(
	'"idArchivoTrabajador":', '"', a.idArchivoTrabajador  , '"', ','  
    '"rutaArchivo":', '"',a.rutaArchivo  ,  '"', ','  
    '"nombreArchivo":', '"',a.nombreArchivo  ,  '"', ','  
    '"Estado":', '"',ifnull((select e.Descripcion from  EstadoValidacion e where e.idEstadoValidacion=a.idEstadoValidacion),'Pendiente') , '"', ','  
    '"tipo":', '"',UPPER(RIGHT(RTRIM(a.nombreArchivo), 4))  , '"', ','  
    '"idTipoDocumentoTrabajador":', '"',a.idTipoDocumentoTrabajador  , '"')
    
 , '}' SEPARATOR ','), ']') 
	  from   ArchivoTrabajador a    
where a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador),'0') as archivos
 from TipoDocumentoTrabajador tdt  
left join TipoDocumentos td on td.idTipoDocumentos=tdt.idTipoDocumentos  
left join EstadoValidacion e on e.idEstadoValidacion=TDT.idEstadoValidacion  
WHERE tdt.IdTrabajador=p_idUsuario;  
  
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_List_DocumentosByTrabajador` (`p_idTrabajador` INT)  begin  
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select tdt.idTipoDocumentoTrabajador,td.Descripcion as TipoDocumento,tdt.idEstadoValidacion,
(SELECT CONCAT('[',GROUP_CONCAT('{',
    CONCAT(
	'"nombreArchivo":', '"', a.nombreArchivo  , '"', ','  
    '"rutaArchivo":', '"',a.rutaArchivo  ,  '"', ','  
    '"tipo":', '"',UPPER(RIGHT(RTRIM(a.nombreArchivo), 4))  , '"', ','  
    '"files":', '"',(case when (select count(*) from ArchivoTrabajador a1 where a1.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador)>=2 then  
'col-lg-6' else 'col-lg-12' end)  , '"')
    
 , '}' SEPARATOR ','), ']') 
	  from   ArchivoTrabajador a    
where a.idTipoDocumentoTrabajador=tdt.idTipoDocumentoTrabajador) as archivos,
(SELECT CONCAT('[',GROUP_CONCAT('{',
    CONCAT(
	'"idEstadoValidacion":', '"', e.idEstadoValidacion  , '"', ','  
    '"Descripcion":', '"',e.Descripcion  , '"', ','  
    '"validado":', '"',case when ifnull(tdt.idEstadoValidacion,'')='' then '' else  'checked' end  , '"')
    
 , '}' SEPARATOR ','), ']') 
	from EstadoValidacion e) as estados
 from TipoDocumentoTrabajador tdt  
left join TipoDocumentos td on td.idTipoDocumentos=tdt.idTipoDocumentos  
where   tdt.IdTrabajador=p_idTrabajador and tdt.existe='Si';  
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_List_DocumentosByTrabajadorv1` (`p_idTrabajador` INT)  BEGIN
select td.Descripcion as TipoDocumento,a.idArchivoTrabajador,a.idEstadoValidacion,
a.rutaArchivo,a.nombreArchivo,
UPPER(RIGHT(RTRIM(a.nombreArchivo), 4)) as tipo,
 ifnull(a.idEstadoValidacion,'') as idEstadoValidacion,
(SELECT CONCAT('[',GROUP_CONCAT('{',
    CONCAT(
	'"idEstadoValidacion":', '"', e.idEstadoValidacion  , '"', ','  
    '"Descripcion":', '"',e.Descripcion  , '"', ','  
    '"validado":', '"',case when ifnull(a.idEstadoValidacion,'')='' then '' else  'checked' end  , '"')
    
 , '}' SEPARATOR ','), ']') 
	from EstadoValidacion e
    where e.idEstadoValidacion not in(5,4)) as estados  from ArchivoTrabajador a
left join TipoDocumentoTrabajador tdt on tdt.idTipoDocumentoTrabajador=a.idTipoDocumentoTrabajador
left join TipoDocumentos td on td.idTipoDocumentos=tdt.idTipoDocumentos 
where tdt.IdTrabajador=p_idTrabajador;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_LoginUsuario` (`p_Dni` VARCHAR(100), `p_Clave` VARCHAR(150))  begin  
   
  
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select t.idTrabajador,t.NombreCompleto,t.Dni,t.idPuestoArchivo,  
(select p.idPerfil from PuestoArchivo p where p.idPuestoArchivo=t.idPuestoArchivo) as IdPerfil,  
(select p.Descripcion from PuestoArchivo p where p.idPuestoArchivo=t.idPuestoArchivo) as PuestoArchivo  
from Trabajador t where t.Dni =p_Dni  and t.Clave=p_Clave;  
  
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_validaDocumento` (`p_idEstado` INT, `p_idtipoDocumentoTrabajador` INT)  begin  
update TipoDocumentoTrabajador set idEstadoValidacion=p_idEstado  
where idTipoDocumentoTrabajador=p_idtipoDocumentoTrabajador;  
  
select  '0' as msj;       
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Usp_validaDocumentov2` (`p_idEstado` INT, `p_idArchivoTrabajador` INT)  begin  

update ArchivoTrabajador set idEstadoValidacion=p_idEstado  
where idArchivoTrabajador=p_idArchivoTrabajador;  
  
select  '0' as msj;       
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_validarClinica` (`p_observacion` VARCHAR(200), `p_estado` VARCHAR(50), `p_idDocTrabjador` INT(11))  begin  
update  ArchivoTrabajador set Observacion=p_observacion ,ValidacionClinica=p_estado  
where idArchivoTrabajador=p_idDocTrabjador;  
select '0' as msj ;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archivotrabajador`
--

CREATE TABLE `archivotrabajador` (
  `idArchivoTrabajador` int(11) NOT NULL,
  `idTipoDocumentoTrabajador` int(11) DEFAULT NULL,
  `rutaArchivo` varchar(500) DEFAULT NULL,
  `nombreArchivo` varchar(500) DEFAULT NULL,
  `idEstadoValidacion` int(11) DEFAULT NULL,
  `Observacion` varchar(500) DEFAULT NULL,
  `ValidacionClinica` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `archivotrabajador`
--

INSERT INTO `archivotrabajador` (`idArchivoTrabajador`, `idTipoDocumentoTrabajador`, `rutaArchivo`, `nombreArchivo`, `idEstadoValidacion`, `Observacion`, `ValidacionClinica`) VALUES
(14, 4, 'Documentos', '12291202S16.s2-Discusión de fuentes Examen final (2).pdf', 1, NULL, NULL),
(15, 2, 'Documentos', '12291224S17.s2-Examen final- Esquema de redacción.pdf', 1, '', 'Ok'),
(42, 5, 'Documentos', '01060155S08.s8 Material del Curso.pdf', 2, NULL, NULL),
(43, 2, 'Documentos', '01060159Ejercicio bd.pdf', 1, NULL, NULL),
(44, 2, 'Documentos', '01060110S17.s2-Examen final- Esquema de redacción.pdf', 2, NULL, NULL),
(52, 33, 'Documentos', '01060149Ejercicio bd.pdf', NULL, NULL, NULL),
(60, 1, 'Documentos', '01060134Contrato locación de servicios - (Enero - 2021) Nelson Rodriguez.pdf', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadovalidacion`
--

CREATE TABLE `estadovalidacion` (
  `idEstadoValidacion` int(11) NOT NULL,
  `Descripcion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estadovalidacion`
--

INSERT INTO `estadovalidacion` (`idEstadoValidacion`, `Descripcion`) VALUES
(1, 'Si'),
(2, 'No'),
(3, 'Si, pero no vigente'),
(4, 'Si Pero no está vigente'),
(5, 'Pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil`
--

CREATE TABLE `perfil` (
  `idPerfil` int(11) NOT NULL,
  `Descripcion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `Descripcion`) VALUES
(1, 'ASISTENCIAL Y/O PROVEEDOR CLÍNICO'),
(2, 'MEDICO STAFF'),
(3, 'ADMINISTRATIVO Y/O PROVEEDOR NO CLINICO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `puestoarchivo`
--

CREATE TABLE `puestoarchivo` (
  `idPuestoArchivo` int(11) NOT NULL,
  `idPerfil` int(11) DEFAULT NULL,
  `Descripcion` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `puestoarchivo`
--

INSERT INTO `puestoarchivo` (`idPuestoArchivo`, `idPerfil`, `Descripcion`) VALUES
(1, 1, 'ENFERMERO ÁREA CRÍTICA'),
(2, 1, 'ENFERMERO ÁREA NO CRÍTICA'),
(3, 1, 'INTERNO DE ENFERMERÍA'),
(4, 1, 'INTERNO DE FARMACIA'),
(5, 1, 'INTERNO DE MEDICINA'),
(6, 1, 'JEFE MÉDICO'),
(7, 1, 'JEFE DE ENFERMERÍA'),
(8, 1, 'JEFE QUÍMICO FARMACÉUTICO'),
(9, 1, 'MÉDICOS  DE ÁREA CRÍTICA'),
(10, 1, 'MÉDICOS  DE ÁREA CRÍTICA'),
(11, 1, 'MÉDICOS DE ÁREA NO CRÍTICA'),
(12, 1, 'NUTRICIONISTA'),
(13, 1, 'OBSTETRIZ'),
(14, 1, 'PARAMÉDICO'),
(15, 1, 'QUÍMICO DE FARMACIA'),
(16, 1, 'TÉCNICO ASISTENCIAL'),
(17, 1, 'TÉCNICO DE FARMACIA'),
(18, 1, 'TECNÓLOGO CDI'),
(19, 1, 'TECNÓLOGO'),
(20, 2, 'CMP - COLEGIO MÉDICO DEL PERÚ'),
(21, 2, 'COP - COLEGIO ODONTOLÓGICO DEL PERÚ'),
(22, 2, 'CPP - COLEGIO DE PSICÓLOGOS DEL PERÚ'),
(23, 2, 'CNP - COLEGIO DE NUTRICIONISTAS DEL PERÚ'),
(24, 2, 'POD - PODÓLOGO'),
(25, 2, 'OPT - OPTÓMETRA'),
(26, 3, 'EJECUTIVO'),
(27, 3, 'EJECUTIVO / MÉDICO'),
(28, 3, 'EMPLEADO'),
(29, 3, 'PROVEEDOR'),
(30, 3, 'JEFATURAS'),
(31, 3, 'ADMISION EMERGENCIA'),
(32, 3, 'PRACTICANTE'),
(33, 1, 'CLINICA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipodocumentos`
--

CREATE TABLE `tipodocumentos` (
  `idTipoDocumentos` int(11) NOT NULL,
  `idPuestoArchivo` int(11) DEFAULT NULL,
  `Descripcion` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipodocumentos`
--

INSERT INTO `tipodocumentos` (`idTipoDocumentos`, `idPuestoArchivo`, `Descripcion`) VALUES
(1, 1, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(2, 1, '1.1.3. Recertificación (Médicos)'),
(3, 1, '1.1.4. Diploma Colegiatura'),
(4, 1, '1.1.5. RNE (Solo Médicos y algunos Enfermeros)'),
(5, 1, '1.1.6. Título de Especialidad'),
(6, 1, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(7, 1, '1.1.8. Grado de Bachiller'),
(8, 1, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(9, 1, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(10, 1, '1.2.4. Reporte de Antecedentes Personales'),
(11, 1, '1.2.5. Informe Psicolaboral'),
(12, 1, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(13, 1, '1.2.7. Evaluación Psicológica'),
(14, 1, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(15, 1, '2.1.1. Copia del DNI del Cuidador'),
(16, 1, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(17, 1, '2.1.3. Acreditación de Cuenta Sueldo'),
(18, 1, '2.1.4. Copia de Recibo de Servicios'),
(19, 1, '2.1.5. Carta Oferta Laboral '),
(20, 1, '2.1.6. Formato Descripción de Puesto /MOF'),
(21, 1, '2.1.7. Fotografía'),
(22, 1, '2.2.1.Certificado de Aptitud Médica '),
(23, 1, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(24, 1, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(25, 1, '2.3.1. Contrato Laboral o Convenio Laboral'),
(26, 1, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(27, 1, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(28, 1, '2.3.6. Constancia de Entrega de Información'),
(29, 2, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(30, 2, '1.1.4. Diploma Colegiatura'),
(31, 2, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(32, 2, '1.1.8. Grado de Bachiller'),
(33, 2, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(34, 2, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(35, 2, '1.2.4. Reporte de Antecedentes Personales'),
(36, 2, '1.2.5. Informe Psicolaboral'),
(37, 2, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(38, 2, '1.2.7. Evaluación Psicológica'),
(39, 2, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(40, 2, '2.1.1. Copia del DNI del Cuidador'),
(41, 2, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(42, 2, '2.1.3. Acreditación de Cuenta Sueldo'),
(43, 2, '2.1.4. Copia de Recibo de Servicios'),
(44, 2, '2.1.5. Carta Oferta Laboral '),
(45, 2, '2.1.6. Formato Descripción de Puesto /MOF'),
(46, 2, '2.1.7. Fotografía'),
(47, 2, '2.2.1.Certificado de Aptitud Médica '),
(48, 2, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(49, 2, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(50, 2, '2.3.1. Contrato Laboral o Convenio Laboral'),
(51, 2, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(52, 2, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(53, 2, '2.3.6. Constancia de Entrega de Información'),
(54, 3, '1.2.3 Carta Present. Univ. Pract.'),
(55, 3, '1.2.4. Reporte de Antecedentes Personales'),
(56, 3, '1.2.5. Informe Psicolaboral'),
(57, 3, '1.2.7. Evaluación Psicológica'),
(58, 3, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(59, 3, '2.1.1. Copia del DNI del Cuidador'),
(60, 3, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(61, 3, '2.1.3. Acreditación de Cuenta Sueldo'),
(62, 3, '2.1.4. Copia de Recibo de Servicios'),
(63, 3, '2.1.6. Formato Descripción de Puesto /MOF'),
(64, 3, '2.1.7. Fotografía'),
(65, 3, '2.2.1.Certificado de Aptitud Médica '),
(66, 3, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(67, 3, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(68, 3, '2.3.1. Contrato Laboral o Convenio Laboral'),
(69, 3, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(70, 3, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(71, 3, '2.3.6. Constancia de Entrega de Información'),
(72, 4, '1.2.3 Carta Present. Univ. Pract.'),
(73, 4, '1.2.4. Reporte de Antecedentes Personales'),
(74, 4, '1.2.5. Informe Psicolaboral'),
(75, 4, '1.2.7. Evaluación Psicológica'),
(76, 4, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(77, 4, '2.1.1. Copia del DNI del Cuidador'),
(78, 4, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(79, 4, '2.1.3. Acreditación de Cuenta Sueldo'),
(80, 4, '2.1.4. Copia de Recibo de Servicios'),
(81, 4, '2.1.6. Formato Descripción de Puesto /MOF'),
(82, 4, '2.1.7. Fotografía'),
(83, 4, '2.2.1.Certificado de Aptitud Médica '),
(84, 4, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(85, 4, '2.2.3. Copia Carnet de Sanidad (Solo Personal Farmacia)'),
(86, 4, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(87, 4, '2.3.1. Contrato Laboral o Convenio Laboral'),
(88, 4, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(89, 4, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(90, 4, '2.3.6. Constancia de Entrega de Información'),
(91, 5, '1.2.3 Carta Present. Univ. Pract.'),
(92, 5, '1.2.4. Reporte de Antecedentes Personales'),
(93, 5, '1.2.5. Informe Psicolaboral'),
(94, 5, '1.2.7. Evaluación Psicológica'),
(95, 5, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(96, 5, '2.1.1. Copia del DNI del Cuidador'),
(97, 5, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(98, 5, '2.1.3. Acreditación de Cuenta Sueldo'),
(99, 5, '2.1.4. Copia de Recibo de Servicios'),
(100, 5, '2.1.6. Formato Descripción de Puesto /MOF'),
(101, 5, '2.1.7. Fotografía'),
(102, 5, '2.2.1.Certificado de Aptitud Médica '),
(103, 5, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(104, 5, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(105, 5, '2.3.1. Contrato Laboral o Convenio Laboral'),
(106, 5, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(107, 5, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(108, 5, '2.3.6. Constancia de Entrega de Información'),
(109, 6, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(110, 6, '1.1.3. Recertificación (Médicos)'),
(111, 6, '1.1.4. Diploma Colegiatura'),
(112, 6, '1.1.5. RNE (Solo Médicos y algunos Enfermeros)'),
(113, 6, '1.1.6. Título de Especialidad'),
(114, 6, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(115, 6, '1.1.8. Grado de Bachiller'),
(116, 6, '1.1.9. Maestría y/o Doctorado'),
(117, 6, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(118, 6, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(119, 6, '1.2.4. Reporte de Antecedentes Personales'),
(120, 6, '1.2.5. Informe Psicolaboral'),
(121, 6, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(122, 6, '1.2.7. Evaluación Psicológica'),
(123, 6, '2.1.1. Copia del DNI del Cuidador'),
(124, 6, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(125, 6, '2.1.3. Acreditación de Cuenta Sueldo'),
(126, 6, '2.1.4. Copia de Recibo de Servicios'),
(127, 6, '2.1.5. Carta Oferta Laboral '),
(128, 6, '2.1.6. Formato Descripción de Puesto /MOF'),
(129, 6, '2.1.7. Fotografía'),
(130, 6, '2.2.1.Certificado de Aptitud Médica '),
(131, 6, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(132, 6, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(133, 6, '2.3.1. Contrato Laboral o Convenio Laboral'),
(134, 6, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(135, 6, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(136, 6, '2.3.6. Constancia de Entrega de Información'),
(137, 7, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(138, 7, '1.1.3. Recertificación (Médicos)'),
(139, 7, '1.1.4. Diploma Colegiatura'),
(140, 7, '1.1.5. RNE (Solo Médicos y algunos Enfermeros)'),
(141, 7, '1.1.6. Título de Especialidad'),
(142, 7, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(143, 7, '1.1.8. Grado de Bachiller'),
(144, 7, '1.1.9. Maestría y/o Doctorado'),
(145, 7, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(146, 7, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(147, 7, '1.2.4. Reporte de Antecedentes Personales'),
(148, 7, '1.2.5. Informe Psicolaboral'),
(149, 7, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(150, 7, '1.2.7. Evaluación Psicológica'),
(151, 7, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(152, 7, '2.1.1. Copia del DNI del Cuidador'),
(153, 7, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(154, 7, '2.1.3. Acreditación de Cuenta Sueldo'),
(155, 7, '2.1.4. Copia de Recibo de Servicios'),
(156, 7, '2.1.5. Carta Oferta Laboral '),
(157, 7, '2.1.6. Formato Descripción de Puesto /MOF'),
(158, 7, '2.1.7. Fotografía'),
(159, 7, '2.2.1.Certificado de Aptitud Médica '),
(160, 7, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(161, 7, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(162, 7, '2.3.1. Contrato Laboral o Convenio Laboral'),
(163, 7, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(164, 7, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(165, 7, '2.3.6. Constancia de Entrega de Información'),
(166, 8, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(167, 8, '1.1.3. Recertificación (Médicos)'),
(168, 8, '1.1.4. Diploma Colegiatura'),
(169, 8, '1.1.5. RNE (Solo Médicos y algunos Enfermeros)'),
(170, 8, '1.1.6. Título de Especialidad'),
(171, 8, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(172, 8, '1.1.8. Grado de Bachiller'),
(173, 8, '1.1.9. Maestría y/o Doctorado'),
(174, 8, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(175, 8, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(176, 8, '1.2.4. Reporte de Antecedentes Personales'),
(177, 8, '1.2.5. Informe Psicolaboral'),
(178, 8, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(179, 8, '1.2.7. Evaluación Psicológica'),
(180, 8, '2.1.1. Copia del DNI del Cuidador'),
(181, 8, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(182, 8, '2.1.3. Acreditación de Cuenta Sueldo'),
(183, 8, '2.1.4. Copia de Recibo de Servicios'),
(184, 8, '2.1.5. Carta Oferta Laboral '),
(185, 8, '2.1.6. Formato Descripción de Puesto /MOF'),
(186, 8, '2.1.7. Fotografía'),
(187, 8, '2.2.1.Certificado de Aptitud Médica '),
(188, 8, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(189, 8, '2.2.3. Copia Carnet de Sanidad (Solo Personal Farmacia)'),
(190, 8, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(191, 8, '2.3.1. Contrato Laboral o Convenio Laboral'),
(192, 8, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(193, 8, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(194, 8, '2.3.6. Constancia de Entrega de Información'),
(195, 9, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(196, 9, '1.1.3. Recertificación (Médicos)'),
(197, 9, '1.1.4. Diploma Colegiatura'),
(198, 9, '1.1.5. RNE (Solo Médicos y algunos Enfermeros)'),
(199, 9, '1.1.6. Título de Especialidad'),
(200, 9, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(201, 9, '1.1.8. Grado de Bachiller'),
(202, 9, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(203, 9, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(204, 9, '1.2.4. Reporte de Antecedentes Personales'),
(205, 9, '1.2.5. Informe Psicolaboral'),
(206, 9, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(207, 9, '1.2.7. Evaluación Psicológica'),
(208, 9, '2.1.1. Copia del DNI del Cuidador'),
(209, 9, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(210, 9, '2.1.3. Acreditación de Cuenta Sueldo'),
(211, 9, '2.1.4. Copia de Recibo de Servicios'),
(212, 9, '2.1.5. Carta Oferta Laboral '),
(213, 9, '2.1.6. Formato Descripción de Puesto /MOF'),
(214, 9, '2.1.7. Fotografía'),
(215, 9, '2.2.1.Certificado de Aptitud Médica '),
(216, 9, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(217, 9, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(218, 9, '2.3.1. Contrato Laboral o Convenio Laboral'),
(219, 9, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(220, 9, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(221, 9, '2.3.6. Constancia de Entrega de Información'),
(222, 11, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(223, 11, '1.1.4. Diploma Colegiatura'),
(224, 11, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(225, 11, '1.1.8. Grado de Bachiller'),
(226, 11, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(227, 11, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(228, 11, '1.2.4. Reporte de Antecedentes Personales'),
(229, 11, '1.2.5. Informe Psicolaboral'),
(230, 11, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(231, 11, '1.2.7. Evaluación Psicológica'),
(232, 11, '2.1.1. Copia del DNI del Cuidador'),
(233, 11, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(234, 11, '2.1.3. Acreditación de Cuenta Sueldo'),
(235, 11, '2.1.4. Copia de Recibo de Servicios'),
(236, 11, '2.1.5. Carta Oferta Laboral '),
(237, 11, '2.1.6. Formato Descripción de Puesto /MOF'),
(238, 11, '2.1.7. Fotografía'),
(239, 11, '2.2.1.Certificado de Aptitud Médica '),
(240, 11, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(241, 11, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(242, 11, '2.3.1. Contrato Laboral o Convenio Laboral'),
(243, 11, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(244, 11, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(245, 11, '2.3.6. Constancia de Entrega de Información'),
(246, 12, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(247, 12, '1.1.4. Diploma Colegiatura'),
(248, 12, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(249, 12, '1.1.8. Grado de Bachiller'),
(250, 12, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(251, 12, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(252, 12, '1.2.4. Reporte de Antecedentes Personales'),
(253, 12, '1.2.5. Informe Psicolaboral'),
(254, 12, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(255, 12, '1.2.7. Evaluación Psicológica'),
(256, 12, '2.1.1. Copia del DNI del Cuidador'),
(257, 12, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(258, 12, '2.1.3. Acreditación de Cuenta Sueldo'),
(259, 12, '2.1.4. Copia de Recibo de Servicios'),
(260, 12, '2.1.5. Carta Oferta Laboral '),
(261, 12, '2.1.6. Formato Descripción de Puesto /MOF'),
(262, 12, '2.1.7. Fotografía'),
(263, 12, '2.2.1.Certificado de Aptitud Médica '),
(264, 12, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(265, 12, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(266, 12, '2.3.1. Contrato Laboral o Convenio Laboral'),
(267, 12, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(268, 12, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(269, 12, '2.3.6. Constancia de Entrega de Información'),
(270, 13, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(271, 13, '1.1.4. Diploma Colegiatura'),
(272, 13, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(273, 13, '1.1.8. Grado de Bachiller'),
(274, 13, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(275, 13, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(276, 13, '1.2.4. Reporte de Antecedentes Personales'),
(277, 13, '1.2.5. Informe Psicolaboral'),
(278, 13, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(279, 13, '1.2.7. Evaluación Psicológica'),
(280, 13, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(281, 13, '2.1.1. Copia del DNI del Cuidador'),
(282, 13, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(283, 13, '2.1.3. Acreditación de Cuenta Sueldo'),
(284, 13, '2.1.4. Copia de Recibo de Servicios'),
(285, 13, '2.1.5. Carta Oferta Laboral '),
(286, 13, '2.1.6. Formato Descripción de Puesto /MOF'),
(287, 13, '2.1.7. Fotografía'),
(288, 13, '2.2.1.Certificado de Aptitud Médica '),
(289, 13, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(290, 13, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(291, 13, '2.3.1. Contrato Laboral o Convenio Laboral'),
(292, 13, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(293, 13, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(294, 13, '2.3.6. Constancia de Entrega de Información'),
(295, 14, '1.2.4. Reporte de Antecedentes Personales'),
(296, 14, '1.2.5. Informe Psicolaboral'),
(297, 14, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(298, 14, '1.2.7. Evaluación Psicológica'),
(299, 14, '2.1.1. Copia del DNI del Cuidador'),
(300, 14, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(301, 14, '2.1.3. Acreditación de Cuenta Sueldo'),
(302, 14, '2.1.4. Copia de Recibo de Servicios'),
(303, 14, '2.1.5. Carta Oferta Laboral '),
(304, 14, '2.1.6. Formato Descripción de Puesto /MOF'),
(305, 14, '2.1.7. Fotografía'),
(306, 14, '2.2.1.Certificado de Aptitud Médica '),
(307, 14, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(308, 14, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(309, 14, '2.3.1. Contrato Laboral o Convenio Laboral'),
(310, 14, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(311, 14, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(312, 14, '2.3.6. Constancia de Entrega de Información'),
(313, 15, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(314, 15, '1.1.4. Diploma Colegiatura'),
(315, 15, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(316, 15, '1.1.8. Grado de Bachiller'),
(317, 15, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(318, 15, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(319, 15, '1.2.4. Reporte de Antecedentes Personales'),
(320, 15, '1.2.5. Informe Psicolaboral'),
(321, 15, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(322, 15, '1.2.7. Evaluación Psicológica'),
(323, 15, '2.1.1. Copia del DNI del Cuidador'),
(324, 15, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(325, 15, '2.1.3. Acreditación de Cuenta Sueldo'),
(326, 15, '2.1.4. Copia de Recibo de Servicios'),
(327, 15, '2.1.5. Carta Oferta Laboral '),
(328, 15, '2.1.6. Formato Descripción de Puesto /MOF'),
(329, 15, '2.1.7. Fotografía'),
(330, 15, '2.2.1.Certificado de Aptitud Médica '),
(331, 15, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(332, 15, '2.2.3. Copia Carnet de Sanidad (Solo Personal Farmacia)'),
(333, 15, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(334, 15, '2.3.1. Contrato Laboral o Convenio Laboral'),
(335, 15, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(336, 15, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(337, 15, '2.3.6. Constancia de Entrega de Información'),
(338, 16, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(339, 16, '1.1.8. Grado de Bachiller'),
(340, 16, '1.2.4. Reporte de Antecedentes Personales'),
(341, 16, '1.2.5. Informe Psicolaboral'),
(342, 16, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(343, 16, '1.2.7. Evaluación Psicológica'),
(344, 16, '1.2.8. Evaluación de Conocimientos (Personal de Enfermería)'),
(345, 16, '2.1.1. Copia del DNI del Cuidador'),
(346, 16, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(347, 16, '2.1.3. Acreditación de Cuenta Sueldo'),
(348, 16, '2.1.4. Copia de Recibo de Servicios'),
(349, 16, '2.1.5. Carta Oferta Laboral '),
(350, 16, '2.1.6. Formato Descripción de Puesto /MOF'),
(351, 16, '2.1.7. Fotografía'),
(352, 16, '2.2.1.Certificado de Aptitud Médica '),
(353, 16, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(354, 16, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(355, 16, '2.3.1. Contrato Laboral o Convenio Laboral'),
(356, 16, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(357, 16, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(358, 16, '2.3.6. Constancia de Entrega de Información'),
(359, 17, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(360, 17, '1.1.8. Grado de Bachiller'),
(361, 17, '1.2.4. Reporte de Antecedentes Personales'),
(362, 17, '1.2.5. Informe Psicolaboral'),
(363, 17, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(364, 17, '1.2.7. Evaluación Psicológica'),
(365, 17, '2.1.1. Copia del DNI del Cuidador'),
(366, 17, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(367, 17, '2.1.3. Acreditación de Cuenta Sueldo'),
(368, 17, '2.1.4. Copia de Recibo de Servicios'),
(369, 17, '2.1.5. Carta Oferta Laboral '),
(370, 17, '2.1.6. Formato Descripción de Puesto /MOF'),
(371, 17, '2.1.7. Fotografía'),
(372, 17, '2.2.1.Certificado de Aptitud Médica '),
(373, 17, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(374, 17, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(375, 17, '2.3.1. Contrato Laboral o Convenio Laboral'),
(376, 17, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(377, 17, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(378, 17, '2.3.6. Constancia de Entrega de Información'),
(379, 18, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(380, 18, '1.1.2. Licencia de IPEN (Solo Tecnólogos de Rediologia)'),
(381, 18, '1.1.4. Diploma Colegiatura'),
(382, 18, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(383, 18, '1.1.8. Grado de Bachiller'),
(384, 18, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(385, 18, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(386, 18, '1.2.4. Reporte de Antecedentes Personales'),
(387, 18, '1.2.5. Informe Psicolaboral'),
(388, 18, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(389, 18, '1.2.7. Evaluación Psicológica'),
(390, 18, '2.1.1. Copia del DNI del Cuidador'),
(391, 18, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(392, 18, '2.1.3. Acreditación de Cuenta Sueldo'),
(393, 18, '2.1.4. Copia de Recibo de Servicios'),
(394, 18, '2.1.5. Carta Oferta Laboral '),
(395, 18, '2.1.6. Formato Descripción de Puesto /MOF'),
(396, 18, '2.1.7. Fotografía'),
(397, 18, '2.2.1.Certificado de Aptitud Médica '),
(398, 18, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(399, 18, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(400, 18, '2.3.1. Contrato Laboral o Convenio Laboral'),
(401, 18, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(402, 18, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(403, 18, '2.3.6. Constancia de Entrega de Información'),
(404, 19, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(405, 19, '1.1.4. Diploma Colegiatura'),
(406, 19, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(407, 19, '1.1.8. Grado de Bachiller'),
(408, 19, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(409, 19, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(410, 19, '1.2.4. Reporte de Antecedentes Personales'),
(411, 19, '1.2.5. Informe Psicolaboral'),
(412, 19, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(413, 19, '1.2.7. Evaluación Psicológica'),
(414, 19, '2.1.1. Copia del DNI del Cuidador'),
(415, 19, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(416, 19, '2.1.3. Acreditación de Cuenta Sueldo'),
(417, 19, '2.1.4. Copia de Recibo de Servicios'),
(418, 19, '2.1.5. Carta Oferta Laboral '),
(419, 19, '2.1.6. Formato Descripción de Puesto /MOF'),
(420, 19, '2.1.7. Fotografía'),
(421, 19, '2.2.1.Certificado de Aptitud Médica '),
(422, 19, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(423, 19, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(424, 19, '2.3.1. Contrato Laboral o Convenio Laboral'),
(425, 19, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(426, 19, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(427, 19, '2.3.6. Constancia de Entrega de Información'),
(428, 20, '5.1.1. Título de Medico Cirujano / Título Profesional'),
(429, 20, '5.1.2. Título de Especialidad'),
(430, 20, '5.1.3. Diploma de Colegio Profesional'),
(431, 20, '5.1.4. RNE'),
(432, 20, '5.1.5. Constancia de habilidad expedida por el colegio profesional  (vigente se renueva cada 3 meses)'),
(433, 20, '5.1.6. Diploma de Recertificación de especialidad vigente (Se renueva cada 5 años)'),
(434, 20, '5.1.7. Certificado de curso de Basic life support (BLS) o equivalente (Se renueva cada 2 años)'),
(435, 20, '5.1.8. Ficha de Privilegios (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(436, 20, '5.1.9. Ficha de afiliación (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(437, 20, '5.1.10. Copia simple o digital del DNI VIgente'),
(438, 20, '5.1.11. Ficha RUC (Obligatorio para persona jurídica)'),
(439, 20, '5.1.12. Reporte de Credenciales'),
(440, 20, '5.1.13. Fotografía tamaño carne en vestimenta formal y fondo blanco (Impresión de fotocheck)'),
(441, 20, '5.1.14. Carta de recomendación/referencia (3 CARTAS)'),
(442, 20, '5.1.15 Verificación SUNEDU'),
(443, 20, '5.1.16  Verificación COLEGIO PROFESIONAL'),
(444, 20, '5.1.17  Verificación SUNAT'),
(445, 20, '5.1.18 Verificación RENIEC'),
(446, 20, '5.1.19 Contrato Staff'),
(447, 20, '5.2.1. Títulos universitarios (maestría, doctorado, post-doctorado), adjuntar copia de los títulos'),
(448, 20, '5.2.2. Docencia, adjuntar constancia expedida por la institución de origen'),
(449, 20, '5.2.3. Publicaciones, adjuntar del resumen de la publicación '),
(450, 20, '5.2.4. Dominio de idiomas, adjuntar certificados y/o constancias de exámenes internacionales  '),
(451, 20, '5.2.5. Rotaciones (fellow, rotation, stage), adjuntar constancia '),
(452, 20, '5.2.6. Entrenamientos, adjuntar constancia expedida por la institución de origen '),
(453, 20, '5.2.7. Ponencias en cursos, congresos o actividad académica, adjuntar constancia.'),
(454, 20, '5.2.8 Trabajo social o benéfico, adjuntar constancia.'),
(455, 20, '5.2.9. Méritos, premios o distinciones, adjuntar constancia. '),
(456, 20, '5.2.10. Participación en trabajos de investigación, ensayos clínicos, adjuntar constancia.'),
(457, 20, '5.2.11. Sociedades médicas o académicas a las cuales pertenece, adjuntar diploma.'),
(458, 20, '5.2.12. Trabajos anteriores, adjuntar constancia expedida por la institución de origen.'),
(459, 20, '5.2.13. Constancia de cursos y congresos (las constancias o certificados no deben tener una antigüedad mayor a 3 años).'),
(460, 21, '5.1.1. Título de Medico Cirujano / Título Profesional'),
(461, 21, '5.1.2. Título de Especialidad'),
(462, 21, '5.1.3. Diploma de Colegio Profesional'),
(463, 21, '5.1.5. Constancia de habilidad expedida por el colegio profesional  (vigente se renueva cada 3 meses)'),
(464, 21, '5.1.7. Certificado de curso de Basic life support (BLS) o equivalente (Se renueva cada 2 años)'),
(465, 21, '5.1.8. Ficha de Privilegios (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(466, 21, '5.1.9. Ficha de afiliación (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(467, 21, '5.1.10. Copia simple o digital del DNI VIgente'),
(468, 21, '5.1.11. Ficha RUC (Obligatorio para persona jurídica)'),
(469, 21, '5.1.12. Reporte de Credenciales'),
(470, 21, '5.1.13. Fotografía tamaño carne en vestimenta formal y fondo blanco (Impresión de fotocheck)'),
(471, 21, '5.1.14. Carta de recomendación/referencia (3 CARTAS)'),
(472, 21, '5.1.15 Verificación SUNEDU'),
(473, 21, '5.1.16  Verificación COLEGIO PROFESIONAL'),
(474, 21, '5.1.17  Verificación SUNAT'),
(475, 21, '5.1.18 Verificación RENIEC'),
(476, 21, '5.1.19 Contrato Staff'),
(477, 21, '5.2.1. Títulos universitarios (maestría, doctorado, post-doctorado), adjuntar copia de los títulos'),
(478, 21, '5.2.2. Docencia, adjuntar constancia expedida por la institución de origen'),
(479, 21, '5.2.4. Dominio de idiomas, adjuntar certificados y/o constancias de exámenes internacionales  '),
(480, 21, '5.2.6. Entrenamientos, adjuntar constancia expedida por la institución de origen '),
(481, 21, '5.2.8 Trabajo social o benéfico, adjuntar constancia.'),
(482, 21, '5.2.9. Méritos, premios o distinciones, adjuntar constancia. '),
(483, 21, '5.2.10. Participación en trabajos de investigación, ensayos clínicos, adjuntar constancia.'),
(484, 21, '5.2.12. Trabajos anteriores, adjuntar constancia expedida por la institución de origen.'),
(485, 21, '5.2.13. Constancia de cursos y congresos (las constancias o certificados no deben tener una antigüedad mayor a 3 años).'),
(486, 22, '5.1.1. Título de Medico Cirujano / Título Profesional'),
(487, 22, '5.1.3. Diploma de Colegio Profesional'),
(488, 22, '5.1.5. Constancia de habilidad expedida por el colegio profesional  (vigente se renueva cada 3 meses)'),
(489, 22, '5.1.7. Certificado de curso de Basic life support (BLS) o equivalente (Se renueva cada 2 años)'),
(490, 22, '5.1.8. Ficha de Privilegios (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(491, 22, '5.1.9. Ficha de afiliación (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(492, 22, '5.1.10. Copia simple o digital del DNI VIgente'),
(493, 22, '5.1.11. Ficha RUC (Obligatorio para persona jurídica)'),
(494, 22, '5.1.12. Reporte de Credenciales'),
(495, 22, '5.1.13. Fotografía tamaño carne en vestimenta formal y fondo blanco (Impresión de fotocheck)'),
(496, 22, '5.1.15 Verificación SUNEDU'),
(497, 22, '5.1.16  Verificación COLEGIO PROFESIONAL'),
(498, 22, '5.1.17  Verificación SUNAT'),
(499, 22, '5.1.18 Verificación RENIEC'),
(500, 22, '5.1.19 Contrato Staff'),
(501, 22, '5.2.1. Títulos universitarios (maestría, doctorado, post-doctorado), adjuntar copia de los títulos'),
(502, 22, '5.2.4. Dominio de idiomas, adjuntar certificados y/o constancias de exámenes internacionales  '),
(503, 22, '5.2.9. Méritos, premios o distinciones, adjuntar constancia. '),
(504, 22, '5.2.12. Trabajos anteriores, adjuntar constancia expedida por la institución de origen.'),
(505, 23, '5.1.1. Título de Medico Cirujano / Título Profesional'),
(506, 23, '5.1.3. Diploma de Colegio Profesional'),
(507, 23, '5.1.5. Constancia de habilidad expedida por el colegio profesional  (vigente se renueva cada 3 meses)'),
(508, 23, '5.1.7. Certificado de curso de Basic life support (BLS) o equivalente (Se renueva cada 2 años)'),
(509, 23, '5.1.8. Ficha de Privilegios (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(510, 23, '5.1.9. Ficha de afiliación (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(511, 23, '5.1.10. Copia simple o digital del DNI VIgente'),
(512, 23, '5.1.11. Ficha RUC (Obligatorio para persona jurídica)'),
(513, 23, '5.1.12. Reporte de Credenciales'),
(514, 23, '5.1.13. Fotografía tamaño carne en vestimenta formal y fondo blanco (Impresión de fotocheck)'),
(515, 23, '5.1.15 Verificación SUNEDU'),
(516, 23, '5.1.16  Verificación COLEGIO PROFESIONAL'),
(517, 23, '5.1.17  Verificación SUNAT'),
(518, 23, '5.1.18 Verificación RENIEC'),
(519, 23, '5.1.19 Contrato Staff'),
(520, 23, '5.2.1. Títulos universitarios (maestría, doctorado, post-doctorado), adjuntar copia de los títulos'),
(521, 23, '5.2.4. Dominio de idiomas, adjuntar certificados y/o constancias de exámenes internacionales  '),
(522, 23, '5.2.9. Méritos, premios o distinciones, adjuntar constancia. '),
(523, 23, '5.2.12. Trabajos anteriores, adjuntar constancia expedida por la institución de origen.'),
(524, 24, '5.1.1. Título de Medico Cirujano / Título Profesional'),
(525, 24, '5.1.7. Certificado de curso de Basic life support (BLS) o equivalente (Se renueva cada 2 años)'),
(526, 24, '5.1.9. Ficha de afiliación (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(527, 24, '5.1.10. Copia simple o digital del DNI VIgente'),
(528, 24, '5.1.11. Ficha RUC (Obligatorio para persona jurídica)'),
(529, 24, '5.1.12. Reporte de Credenciales'),
(530, 24, '5.1.13. Fotografía tamaño carne en vestimenta formal y fondo blanco (Impresión de fotocheck)'),
(531, 24, '5.1.17  Verificación SUNAT'),
(532, 24, '5.1.18 Verificación RENIEC'),
(533, 24, '5.1.19 Contrato Staff'),
(534, 24, '5.2.1. Títulos universitarios (maestría, doctorado, post-doctorado), adjuntar copia de los títulos'),
(535, 24, '5.2.4. Dominio de idiomas, adjuntar certificados y/o constancias de exámenes internacionales  '),
(536, 24, '5.2.12. Trabajos anteriores, adjuntar constancia expedida por la institución de origen.'),
(537, 25, '5.1.1. Título de Medico Cirujano / Título Profesional'),
(538, 25, '5.1.7. Certificado de curso de Basic life support (BLS) o equivalente (Se renueva cada 2 años)'),
(539, 25, '5.1.9. Ficha de afiliación (enviado por la Oficina de Credenciales y Privilegios desde el correo ocp@cinternacional.com.pe)'),
(540, 25, '5.1.10. Copia simple o digital del DNI VIgente'),
(541, 25, '5.1.11. Ficha RUC (Obligatorio para persona jurídica)'),
(542, 25, '5.1.12. Reporte de Credenciales'),
(543, 25, '5.1.13. Fotografía tamaño carne en vestimenta formal y fondo blanco (Impresión de fotocheck)'),
(544, 25, '5.1.17  Verificación SUNAT'),
(545, 25, '5.1.18 Verificación RENIEC'),
(546, 25, '5.1.19 Contrato Staff'),
(547, 25, '5.2.1. Títulos universitarios (maestría, doctorado, post-doctorado), adjuntar copia de los títulos'),
(548, 25, '5.2.4. Dominio de idiomas, adjuntar certificados y/o constancias de exámenes internacionales  '),
(549, 25, '5.2.12. Trabajos anteriores, adjuntar constancia expedida por la institución de origen.'),
(550, 26, '1.1.4. Diploma Colegiatura'),
(551, 26, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(552, 26, '1.1.8. Grado de Bachiller'),
(553, 26, '1.1.9. Maestría y/o Doctorado'),
(554, 26, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(555, 26, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(556, 26, '1.2.4. Reporte de Antecedentes Personales'),
(557, 26, '1.2.5. Informe Psicolaboral'),
(558, 26, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(559, 26, '1.2.7. Evaluación Psicológica'),
(560, 26, '2.1.1. Copia del DNI del Cuidador'),
(561, 26, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(562, 26, '2.1.3. Acreditación de Cuenta Sueldo'),
(563, 26, '2.1.4. Copia de Recibo de Servicios'),
(564, 26, '2.1.5. Carta Oferta Laboral '),
(565, 26, '2.1.6. Formato Descripción de Puesto /MOF'),
(566, 26, '2.1.7. Fotografía'),
(567, 26, '2.2.1.Certificado de Aptitud Médica '),
(568, 26, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(569, 26, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(570, 26, '2.3.1. Contrato Laboral o Convenio Laboral'),
(571, 26, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(572, 26, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(573, 26, '2.3.6. Constancia de Entrega de Información'),
(574, 27, '1.1.1. Constancia de Habilidad (Asistencial Colegiado)'),
(575, 27, '1.1.3. Recertificación (Médicos)'),
(576, 27, '1.1.4. Diploma Colegiatura'),
(577, 27, '1.1.5. RNE (Solo Médicos y algunos Enfermeros)'),
(578, 27, '1.1.6. Título de Especialidad'),
(579, 27, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(580, 27, '1.1.8. Grado de Bachiller'),
(581, 27, '1.1.9. Maestría y/o Doctorado'),
(582, 27, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(583, 27, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(584, 27, '1.2.4. Reporte de Antecedentes Personales'),
(585, 27, '1.2.5. Informe Psicolaboral'),
(586, 27, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(587, 27, '1.2.7. Evaluación Psicológica'),
(588, 27, '2.1.1. Copia del DNI del Cuidador'),
(589, 27, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(590, 27, '2.1.3. Acreditación de Cuenta Sueldo'),
(591, 27, '2.1.4. Copia de Recibo de Servicios'),
(592, 27, '2.1.5. Carta Oferta Laboral '),
(593, 27, '2.1.6. Formato Descripción de Puesto /MOF'),
(594, 27, '2.1.7. Fotografía'),
(595, 27, '2.2.1.Certificado de Aptitud Médica '),
(596, 27, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(597, 27, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(598, 27, '2.3.1. Contrato Laboral o Convenio Laboral'),
(599, 27, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(600, 27, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(601, 27, '2.3.6. Constancia de Entrega de Información'),
(602, 28, '1.1.10. Currículum Vitae (diplomados y certificados de trabajos previos)'),
(603, 28, '1.2.4. Reporte de Antecedentes Personales'),
(604, 28, '1.2.5. Informe Psicolaboral'),
(605, 28, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(606, 28, '1.2.7. Evaluación Psicológica'),
(607, 28, '2.1.1. Copia del DNI del Cuidador'),
(608, 28, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(609, 28, '2.1.3. Acreditación de Cuenta Sueldo'),
(610, 28, '2.1.4. Copia de Recibo de Servicios'),
(611, 28, '2.1.5. Carta Oferta Laboral '),
(612, 28, '2.1.6. Formato Descripción de Puesto /MOF'),
(613, 28, '2.1.7. Fotografía'),
(614, 28, '2.2.1.Certificado de Aptitud Médica '),
(615, 28, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(616, 28, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(617, 28, '2.3.1. Contrato Laboral o Convenio Laboral'),
(618, 28, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(619, 28, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(620, 28, '2.3.6. Constancia de Entrega de Información'),
(621, 29, '1.1.10. Currículum Vitae (diplomados y certificados de trabajos previos)'),
(622, 29, '1.2.4. Reporte de Antecedentes Personales'),
(623, 29, '2.1.1. Copia del DNI del Cuidador'),
(624, 29, '2.1.6. Formato Descripción de Puesto /MOF'),
(625, 29, '2.2.1.Certificado de Aptitud Médica '),
(626, 29, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(627, 29, '2.2.3. Copia Carnet de Sanidad (Solo Personal Farmacia)'),
(628, 29, '2.3.6. Constancia de Entrega de Información'),
(629, 30, '1.1.7. Título Profesiónal a Nombre de la Nación'),
(630, 30, '1.1.8. Grado de Bachiller'),
(631, 30, '1.2.1. Verificación Grados y T.(Solo Personal Asistencial)'),
(632, 30, '1.2.2. Verificación en Colegio Prof.(Personal Asistencial)'),
(633, 30, '1.2.4. Reporte de Antecedentes Personales'),
(634, 30, '1.2.5. Informe Psicolaboral'),
(635, 30, '1.2.6. Carta de Recomendaciones/ Referencias Laborales'),
(636, 30, '1.2.7. Evaluación Psicológica'),
(637, 30, '2.1.1. Copia del DNI del Cuidador'),
(638, 30, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(639, 30, '2.1.3. Acreditación de Cuenta Sueldo'),
(640, 30, '2.1.4. Copia de Recibo de Servicios'),
(641, 30, '2.1.5. Carta Oferta Laboral '),
(642, 30, '2.1.6. Formato Descripción de Puesto /MOF'),
(643, 30, '2.1.7. Fotografía'),
(644, 30, '2.2.1.Certificado de Aptitud Médica '),
(645, 30, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(646, 30, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(647, 30, '2.3.1. Contrato Laboral o Convenio Laboral'),
(648, 30, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(649, 30, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(650, 30, '2.3.6. Constancia de Entrega de Información'),
(651, 31, '5.1.14. Carta de recomendación/referencia (3 CARTAS)'),
(652, 32, '1.2.3 Carta Present. Univ. Pract.'),
(653, 32, '1.2.4. Reporte de Antecedentes Personales'),
(654, 32, '1.2.5. Informe Psicolaboral'),
(655, 32, '1.2.7. Evaluación Psicológica'),
(656, 32, '2.1.1. Copia del DNI del Cuidador'),
(657, 32, '2.1.2. Copia del DNI de Derechohabientes (Esposa e Hijos)'),
(658, 32, '2.1.3. Acreditación de Cuenta Sueldo'),
(659, 32, '2.1.4. Copia de Recibo de Servicios'),
(660, 32, '2.1.6. Formato Descripción de Puesto /MOF'),
(661, 32, '2.1.7. Fotografía'),
(662, 32, '2.2.1.Certificado de Aptitud Médica '),
(663, 32, '2.2.2. Cartilla de Vacunación / Examen Inmunoglobulina'),
(664, 32, '2.2.4.||Examen Médico Ocupacional de Retiro o Solicitud de Exoneración'),
(665, 32, '2.3.1. Contrato Laboral o Convenio Laboral'),
(666, 32, '2.3.2. Anexo 1: Recomendaciones en Materia de Seguridad y Salud en el Trabajo.'),
(667, 32, '2.3.3.  Anexo 2: Convenio sobre Protección de Datos Personales.'),
(668, 32, '2.3.6. Constancia de Entrega de Información');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipodocumentotrabajador`
--

CREATE TABLE `tipodocumentotrabajador` (
  `idTipoDocumentoTrabajador` int(11) NOT NULL,
  `IdTrabajador` int(11) DEFAULT NULL,
  `idTipoDocumentos` int(11) DEFAULT NULL,
  `existe` varchar(10) DEFAULT NULL,
  `idEstadoValidacion` int(11) DEFAULT NULL,
  `Observacion` varchar(500) DEFAULT NULL,
  `ValidacionClinica` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipodocumentotrabajador`
--

INSERT INTO `tipodocumentotrabajador` (`idTipoDocumentoTrabajador`, `IdTrabajador`, `idTipoDocumentos`, `existe`, `idEstadoValidacion`, `Observacion`, `ValidacionClinica`) VALUES
(1, 1, 428, 'Si', 5, 'ilegible', 'Rechazado'),
(2, 1, 429, 'Si', 5, 'invalido', 'Rechazado'),
(3, 1, 430, 'Si', 5, '', 'Ok'),
(4, 1, 431, 'Si', 5, NULL, NULL),
(5, 1, 432, 'Si', 5, NULL, NULL),
(6, 1, 433, 'Si', 5, NULL, NULL),
(7, 1, 434, 'Si', 4, NULL, NULL),
(8, 1, 435, 'Si', 5, NULL, NULL),
(9, 1, 436, 'Si', 5, NULL, NULL),
(10, 1, 437, 'Si', 5, NULL, NULL),
(11, 1, 438, 'Si', 5, NULL, NULL),
(12, 1, 439, 'Si', 5, NULL, NULL),
(13, 1, 440, 'Si', 5, NULL, NULL),
(14, 1, 441, 'Si', 5, NULL, NULL),
(15, 1, 442, 'Si', 5, NULL, NULL),
(16, 1, 443, 'Si', 3, NULL, NULL),
(17, 1, 444, 'Si', 2, NULL, NULL),
(18, 1, 445, 'Si', 5, NULL, NULL),
(19, 1, 446, 'No', NULL, NULL, NULL),
(20, 1, 447, 'Si', 5, NULL, NULL),
(21, 1, 448, 'No', NULL, NULL, NULL),
(22, 1, 449, 'No', NULL, NULL, NULL),
(23, 1, 450, 'Si', 5, NULL, NULL),
(24, 1, 451, 'Si', 5, NULL, NULL),
(25, 1, 452, 'Si', 5, NULL, NULL),
(26, 1, 453, 'Si', 5, NULL, NULL),
(27, 1, 454, 'Si', 5, NULL, NULL),
(28, 1, 455, 'Si', 5, NULL, NULL),
(29, 1, 456, 'Si', 5, NULL, NULL),
(30, 1, 457, 'Si', 5, NULL, NULL),
(31, 1, 458, 'Si', 5, NULL, NULL),
(32, 1, 459, 'Si', 5, NULL, NULL),
(33, 4, 246, 'Si', 5, NULL, NULL),
(34, 4, 247, 'No', NULL, NULL, NULL),
(35, 4, 248, 'No', NULL, NULL, NULL),
(36, 4, 249, 'No', NULL, NULL, NULL),
(37, 4, 250, 'No', NULL, NULL, NULL),
(38, 4, 251, 'No', NULL, NULL, NULL),
(39, 4, 252, 'No', NULL, NULL, NULL),
(40, 4, 253, 'No', NULL, NULL, NULL),
(41, 4, 254, 'No', NULL, NULL, NULL),
(42, 4, 255, 'No', NULL, NULL, NULL),
(43, 4, 256, 'No', NULL, NULL, NULL),
(44, 4, 257, 'No', NULL, NULL, NULL),
(45, 4, 258, 'No', NULL, NULL, NULL),
(46, 4, 259, 'No', NULL, NULL, NULL),
(47, 4, 260, 'No', NULL, NULL, NULL),
(48, 4, 261, 'No', NULL, NULL, NULL),
(49, 4, 262, 'No', NULL, NULL, NULL),
(50, 4, 263, 'No', NULL, NULL, NULL),
(51, 4, 264, 'No', NULL, NULL, NULL),
(52, 4, 265, 'No', NULL, NULL, NULL),
(53, 4, 266, 'No', NULL, NULL, NULL),
(54, 4, 267, 'No', NULL, NULL, NULL),
(55, 4, 268, 'No', NULL, NULL, NULL),
(56, 4, 269, 'No', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trabajador`
--

CREATE TABLE `trabajador` (
  `idTrabajador` int(11) NOT NULL,
  `idPuestoArchivo` int(11) DEFAULT NULL,
  `NombreCompleto` varchar(100) DEFAULT NULL,
  `Dni` varchar(200) DEFAULT NULL,
  `Clave` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `trabajador`
--

INSERT INTO `trabajador` (`idTrabajador`, `idPuestoArchivo`, `NombreCompleto`, `Dni`, `Clave`) VALUES
(1, 20, 'Nelson Rodriguez', '74352319', '123'),
(2, 33, 'CLINICA', 'admin', '123'),
(4, 12, 'Maycol', '74352311', '321');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `archivotrabajador`
--
ALTER TABLE `archivotrabajador`
  ADD PRIMARY KEY (`idArchivoTrabajador`),
  ADD KEY `idTipoDocumentoTrabajador` (`idTipoDocumentoTrabajador`),
  ADD KEY `archivoValidacion_kf_estado` (`idEstadoValidacion`);

--
-- Indices de la tabla `estadovalidacion`
--
ALTER TABLE `estadovalidacion`
  ADD PRIMARY KEY (`idEstadoValidacion`);

--
-- Indices de la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`idPerfil`);

--
-- Indices de la tabla `puestoarchivo`
--
ALTER TABLE `puestoarchivo`
  ADD PRIMARY KEY (`idPuestoArchivo`),
  ADD KEY `idPerfil` (`idPerfil`);

--
-- Indices de la tabla `tipodocumentos`
--
ALTER TABLE `tipodocumentos`
  ADD PRIMARY KEY (`idTipoDocumentos`),
  ADD KEY `idPuestoArchivo` (`idPuestoArchivo`);

--
-- Indices de la tabla `tipodocumentotrabajador`
--
ALTER TABLE `tipodocumentotrabajador`
  ADD PRIMARY KEY (`idTipoDocumentoTrabajador`),
  ADD KEY `IdTrabajador` (`IdTrabajador`),
  ADD KEY `idTipoDocumentos` (`idTipoDocumentos`);

--
-- Indices de la tabla `trabajador`
--
ALTER TABLE `trabajador`
  ADD PRIMARY KEY (`idTrabajador`),
  ADD KEY `idPuestoArchivo` (`idPuestoArchivo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `archivotrabajador`
--
ALTER TABLE `archivotrabajador`
  MODIFY `idArchivoTrabajador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de la tabla `estadovalidacion`
--
ALTER TABLE `estadovalidacion`
  MODIFY `idEstadoValidacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `perfil`
--
ALTER TABLE `perfil`
  MODIFY `idPerfil` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `puestoarchivo`
--
ALTER TABLE `puestoarchivo`
  MODIFY `idPuestoArchivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `tipodocumentos`
--
ALTER TABLE `tipodocumentos`
  MODIFY `idTipoDocumentos` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=669;

--
-- AUTO_INCREMENT de la tabla `tipodocumentotrabajador`
--
ALTER TABLE `tipodocumentotrabajador`
  MODIFY `idTipoDocumentoTrabajador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT de la tabla `trabajador`
--
ALTER TABLE `trabajador`
  MODIFY `idTrabajador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `archivotrabajador`
--
ALTER TABLE `archivotrabajador`
  ADD CONSTRAINT `archivoValidacion_kf_estado` FOREIGN KEY (`idEstadoValidacion`) REFERENCES `estadovalidacion` (`idEstadoValidacion`),
  ADD CONSTRAINT `archivotrabajador_ibfk_1` FOREIGN KEY (`idTipoDocumentoTrabajador`) REFERENCES `tipodocumentotrabajador` (`idTipoDocumentoTrabajador`);

--
-- Filtros para la tabla `puestoarchivo`
--
ALTER TABLE `puestoarchivo`
  ADD CONSTRAINT `puestoarchivo_ibfk_1` FOREIGN KEY (`idPerfil`) REFERENCES `perfil` (`idPerfil`);

--
-- Filtros para la tabla `tipodocumentos`
--
ALTER TABLE `tipodocumentos`
  ADD CONSTRAINT `tipodocumentos_ibfk_1` FOREIGN KEY (`idPuestoArchivo`) REFERENCES `puestoarchivo` (`idPuestoArchivo`);

--
-- Filtros para la tabla `tipodocumentotrabajador`
--
ALTER TABLE `tipodocumentotrabajador`
  ADD CONSTRAINT `tipodocumentotrabajador_ibfk_1` FOREIGN KEY (`IdTrabajador`) REFERENCES `trabajador` (`idTrabajador`),
  ADD CONSTRAINT `tipodocumentotrabajador_ibfk_2` FOREIGN KEY (`idTipoDocumentos`) REFERENCES `tipodocumentos` (`idTipoDocumentos`);

--
-- Filtros para la tabla `trabajador`
--
ALTER TABLE `trabajador`
  ADD CONSTRAINT `trabajador_ibfk_1` FOREIGN KEY (`idPuestoArchivo`) REFERENCES `puestoarchivo` (`idPuestoArchivo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
