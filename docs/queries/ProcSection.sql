IF OBJECT_ID ('dbo.ProcSection') IS NOT NULL
	DROP PROCEDURE dbo.ProcSection
GO

CREATE PROCEDURE ProcSection
    (	
		@companycode VARCHAR(3),
		@sectioncode VARCHAR(5),
		@sectionname VARCHAR(40),
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
	        IF  (EXISTS(SELECT SectionCode FROM Sections WHERE CompanyCode = @companycode AND SectionCode = @SectionCode))
	        			
	        	BEGIN
					UPDATE Sections SET SectionName = @sectionname,
							CreatedDate = @createddate,
							UpdatedDate = @updateddate,
							UpdatedBy = @updatedby
					WHERE CompanyCode = @companycode
					AND SectionCode = @sectioncode
	        						
	            	SET @results = 1
	            END 
	        ELSE
	            BEGIN
					    
					INSERT INTO Sections(CompanyCode, SectionCode, SectionName,
							CreatedDate, UpdatedDate, UpdatedBy)
							VALUES (@companycode, @sectioncode, @sectionname, 
							@createddate, @updateddate, @updatedby)
					
	            	SET @results = 0
            	
        		END 
        
		--Delete 
		ELSE
			BEGIN
			
				IF (EXISTS(SELECT * FROM Sections 
						WHERE CompanyCode = @companycode 
						AND SectionCode = @sectioncode
						AND DeletedDate IS NULL))
						
					BEGIN
					
						UPDATE Sections SET DeletedDate = getdate(),
							UpdatedBy = @updatedby
							WHERE CompanyCode = @companycode
							AND SectionCode = @sectioncode
					END
				ELSE
					
					BEGIN
				
						UPDATE Sections SET DeletedDate = NULL,
								UpdatedBy = @updatedby
								WHERE CompanyCode = @companycode
								AND SectionCode = @sectioncode
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

