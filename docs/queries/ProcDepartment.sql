IF OBJECT_ID ('dbo.ProcDepartment') IS NOT NULL
	DROP PROCEDURE dbo.ProcDepartment
GO

CREATE PROCEDURE ProcDepartment
    (	
		@companycode VARCHAR(3),
		@departmentcode VARCHAR(3),
		@departmentname VARCHAR(40),
		@createddate DATETIME,
		@updateddate DATETIME,
		@updatedby VARCHAR(7),
		@option BIT
    )
AS

BEGIN

	-- declaring variables
	DECLARE @results VARCHAR(255)
	
	-- try catch error
	BEGIN TRY
	
		--Insert / Update
		IF @option = 1
	        IF  (EXISTS(SELECT DepartmentCode FROM Departments WHERE CompanyCode = @companycode AND DepartmentCode = @departmentcode))
	        			
	        	BEGIN
					UPDATE Departments SET DepartmentName = @departmentname,
						CreatedDate = @createddate,
						UpdatedDate = @updateddate,
						UpdatedBy = @updatedby
						WHERE CompanyCode = @companycode
						AND DepartmentCode = @departmentcode
	        						
	            	SET @results = 1
	            END 
	        ELSE
	            BEGIN
					    
					INSERT INTO Departments(CompanyCode, DepartmentCode, DepartmentName,
						CreatedDate, UpdatedDate, UpdatedBy)
						VALUES (@companycode, @departmentcode, @departmentname, 
						@createddate, @updateddate, @updatedby)
					
	            	SET @results = 0
            	
        		END
        		
		--Delete
		ELSE
			BEGIN
			
				IF	(EXISTS(SELECT * FROM Departments 
						WHERE CompanyCode = @companycode
						AND DepartmentCode = @departmentcode AND DeletedDate IS NULL))
						
					BEGIN
						UPDATE Departments SET DeletedDate = getdate(),
							UpdatedBy = @updatedby
							WHERE CompanyCode = @companycode
							AND DepartmentCode = @departmentcode
					END
				ELSE
				
					BEGIN
						UPDATE Departments SET DeletedDate = NULL,
							UpdatedBy = @updatedby
							WHERE CompanyCode = @companycode
							AND DepartmentCode = @departmentcode
					END
								
            		SET @results = 1
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

