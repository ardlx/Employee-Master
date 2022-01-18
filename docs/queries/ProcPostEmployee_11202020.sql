IF OBJECT_ID ('dbo.ProcPostEmployee') IS NOT NULL
	DROP PROCEDURE dbo.ProcPostEmployee
GO

CREATE PROCEDURE ProcPostEmployee
    (	
	  	@companycode VARCHAR(3),
		@employeecode VARCHAR(7),
		@agencycode VARCHAR(3),
		@employeename VARCHAR(255),
		@nickname VARCHAR(20),
		@departmentcode VARCHAR(3),
		@sectioncode VARCHAR(5),
		@teamcode VARCHAR(5),
		@designationcode VARCHAR(3),
		@contractstatus VARCHAR(1),
		@contracthireddate DATETIME,
		@regularhireddate DATETIME,
		@retireddate DATETIME,
		@gender VARCHAR(1),
		@datebirth DATETIME,
		@createddate DATETIME,
		@deleteddate DATETIME,
		@updateddate DATETIME,
		@updatedby VARCHAR(7)
    )
AS

BEGIN

	-- declaring variables
	DECLARE @results VARCHAR(255)
	
	-- try catch error
	BEGIN TRY
        IF  (EXISTS(SELECT EmployeeCode FROM Employees WHERE EmployeeCode = @employeecode))
        			
        	BEGIN
        		UPDATE Employees
					SET CompanyCode = @companycode, AgencyCode = @agencycode, EmployeeName = @employeename,
						NickName = @nickname, DepartmentCode = @departmentcode, SectionCode = @sectioncode,
						TeamCode = @teamcode, DesignationCode = @designationcode, ContractStatus = @contractstatus,
						ContractHiredDate = @contracthireddate, RegularHiredDate = @regularhireddate,
						RetiredDate = @retireddate, Gender = @gender, DateBirth = @datebirth, CreatedDate = @createddate,
						DeletedDate = @deleteddate, UpdatedDate = @updateddate, UpdatedBy = @updatedby
					WHERE EmployeeCode = @employeecode

        						
            	SET @results = 1
            END 
        ELSE
            BEGIN
            
				INSERT INTO Employees (CompanyCode, EmployeeCode ,AgencyCode, EmployeeName, NickName, 
										DepartmentCode, SectionCode, TeamCode, DesignationCode, ContractStatus, 
										ContractHiredDate, RegularHiredDate, RetiredDate, Gender, DateBirth, 
										CreatedDate, DeletedDate, UpdatedDate, UpdatedBy)
				VALUES (@companycode, @employeecode, @agencycode, @employeename, @nickname, @departmentcode, @sectioncode,
						@teamcode, @designationcode, @contractstatus, @contracthireddate, @regularhireddate, @retireddate,
						@gender, @datebirth, @createddate, @deleteddate, @updateddate, @updatedby)
						
						
						
            	SET @results = 0
        	END
 	 END TRY
     
     --catch the error
     BEGIN CATCH
 		SET @results = 404
     END CATCH
     
	 -- return the message of query
	 SELECT @results AS Results
END



GO

