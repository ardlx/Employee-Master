IF OBJECT_ID ('dbo.EmployeeInformationView') IS NOT NULL
	DROP VIEW dbo.EmployeeInformationView
GO

CREATE VIEW EmployeeInformationView AS

SELECT
Employees.CompanyCode,
Companies.CompanyName,
Companies.ShortName,
Employees.EmployeeCode,
Employees.AgencyCode,
Employees.EmployeeName,
Employees.NickName,
Employees.DepartmentCode,
Departments.DepartmentName,
Employees.SectionCode,
Sections.SectionName,
Employees.TeamCode,
teams.TeamName,
Employees.DesignationCode,
Designations.DesignationName,
Employees.ContractStatus,
Employees.ContractHiredDate,
Employees.RegularHiredDate,
Employees.RetiredDate,
Employees.Gender,
Employees.DateBirth


FROM Employees

LEFT JOIN Companies
ON Employees.CompanyCode = Companies.CompanyCode

LEFT JOIN Departments
ON Employees.CompanyCode = Departments.CompanyCode
AND Employees.DepartmentCode = Departments.DepartmentCode

LEFT JOIN Sections
ON Employees.CompanyCode = Sections.CompanyCode
AND Employees.SectionCode = Sections.SectionCode

LEFT JOIN Teams
ON Employees.CompanyCode = Teams.CompanyCode
AND Employees.TeamCode = Teams.TeamCode


LEFT JOIN Designations
ON Employees.CompanyCode = Designations.CompanyCode
AND Employees.DesignationCode = Designations.DesignationCode

WHERE (Employees.RetiredDate IS NULL OR Employees.RetiredDate <= convert(VARCHAR(10), getdate(), 111))
AND Employees.DeletedDate IS NULL


GO

