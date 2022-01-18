IF OBJECT_ID ('dbo.ProcDivSecteam') IS NOT NULL
	DROP PROCEDURE dbo.ProcDivSecteam
GO

CREATE PROCEDURE ProcDivSecteam
    (	
		@companycode VARCHAR(3),
		@departmentcode VARCHAR(4),
		@sectioncode VARCHAR(5),
		@teamcode VARCHAR(5),
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
	
		--@option = 1: Insert / Update
		IF @option = 1
			-- check if exists
	        IF  (EXISTS(SELECT * FROM DepartmentSectionRelations 
	        			WHERE CompanyCode = @companycode 
	        			AND DepartmentCode = @departmentcode
	        			AND SectionCode = @sectioncode) 
				OR EXISTS(SELECT * FROM SectionTeamRelations 
	        			WHERE CompanyCode = @companycode 
	        			AND DepartmentCode = @departmentcode
	        			AND SectionCode = @sectioncode
	        			AND TeamCode = @teamcode))
	        			
	        	BEGIN
	        	
					UPDATE DepartmentSectionRelations
						SET SectionCode = @sectioncode,
						CreatedDate = @createddate,
						UpdatedDate = @updateddate,
						UpdatedBy = @updatedby
						WHERE CompanyCode = @companycode
						AND DepartmentCode = @departmentcode
						AND SectionCode = @sectioncode;
						
					UPDATE SectionTeamRelations
						SET SectionCode = @sectioncode,
						TeamCode = @teamcode,
						CreatedDate = @createddate,
						UpdatedDate = @updateddate,
						UpdatedBy = @updatedby
						WHERE CompanyCode = @companycode
						AND DepartmentCode = @departmentcode
						AND SectionCode = @sectioncode
						AND TeamCode = @teamcode;				
	        						
	            	SET @results = 1
	            END 
	            
	        --Inserting of data
	        ELSE
	            BEGIN
	            
					INSERT INTO DepartmentSectionRelations
						(CompanyCode, DepartmentCode, SectionCode, CreatedDate, UpdatedDate, UpdatedBy)
						VALUES (@companycode, @departmentcode, @sectioncode, @createddate, @updateddate, @updatedby);
	            
					INSERT INTO SectionTeamRelations
						(CompanyCode, DepartmentCode, SectionCode, TeamCode, CreatedDate, UpdatedDate, UpdatedBy)
						VALUES (@companycode, @departmentcode, @sectioncode, @teamcode, @createddate, @updateddate, @updatedby)
					
	            	SET @results = 0
            	
        		END
        		
		--Deleting of data
		ELSE
			BEGIN
		        IF  (EXISTS(SELECT * FROM DepartmentSectionRelations 
		        			WHERE CompanyCode = @companycode 
		        			AND DepartmentCode = @departmentcode
		        			AND SectionCode = @sectioncode
		        			AND DeletedDate IS NULL) 
					OR EXISTS(SELECT * FROM SectionTeamRelations 
		        			WHERE CompanyCode = @companycode 
		        			AND DepartmentCode = @departmentcode
		        			AND SectionCode = @sectioncode
		        			AND TeamCode = @teamcode
		        			AND DeletedDate IS NULL))
		        	BEGIN
		        		
	        	
						UPDATE DepartmentSectionRelations
							SET DeletedDate = getdate(),
								UpdatedDate = @updateddate,
								UpdatedBy = @updatedby
								WHERE CompanyCode = @companycode
								AND DepartmentCode = @departmentcode	
								AND SectionCode = @sectioncode;
							
						UPDATE SectionTeamRelations
							SET DeletedDate = getdate(),
								UpdatedDate = @updateddate,
								UpdatedBy = @updatedby
								WHERE CompanyCode = @companycode
								AND DepartmentCode = @departmentcode
								AND SectionCode = @sectioncode
								AND TeamCode = @teamcode;
					END
					
				ELSE
				
		        	BEGIN
		        		
	        	
						UPDATE DepartmentSectionRelations
							SET DeletedDate = NULL,
								UpdatedDate = @updateddate,
								UpdatedBy = @updatedby
								WHERE CompanyCode = @companycode
								AND DepartmentCode = @departmentcode	
								AND SectionCode = @sectioncode;
							
						UPDATE SectionTeamRelations
							SET DeletedDate = NULL,
								UpdatedDate = @updateddate,
								UpdatedBy = @updatedby
								WHERE CompanyCode = @companycode
								AND DepartmentCode = @departmentcode
								AND SectionCode = @sectioncode
								AND TeamCode = @teamcode;
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

