IF OBJECT_ID ('dbo.ProcTeam') IS NOT NULL
	DROP PROCEDURE dbo.ProcTeam
GO

CREATE PROCEDURE ProcTeam
    (	
		@companycode VARCHAR(3),
		@teamcode VARCHAR(5),
		@teamname VARCHAR(40),
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
	        IF  (EXISTS(SELECT TeamCode FROM Teams WHERE CompanyCode = @companycode AND TeamCode = @TeamCode))
	        			
	        	BEGIN
					UPDATE Teams SET TeamName = @teamname,
						CreatedDate = @createddate,
						UpdatedDate = @updateddate,
						UpdatedBy = @updatedby
						WHERE CompanyCode = @companycode
						AND TeamCode = @teamcode
	        						
	            	SET @results = 1
	            END 
	        ELSE
	            BEGIN
					    
					INSERT INTO Teams(CompanyCode, TeamCode, TeamName,
						CreatedDate, UpdatedDate, UpdatedBy)
						VALUES (@companycode, @teamcode, @teamname, 
						@createddate, @updateddate, @updatedby)
					
	            	SET @results = 0
            	
        		END
		
		--Delete
		ELSE
			BEGIN
			
				IF (EXISTS(SELECT * FROM Teams 
							WHERE CompanyCode = @companycode
							AND TeamCode = @teamcode
							AND DeletedDate IS NULL))
					BEGIN
					
						UPDATE Teams SET DeletedDate = getdate(),
							UpdatedBy = @updatedby
							WHERE CompanyCode = @companycode
							AND TeamCode = @teamcode
					END
					
				ELSE
				
					BEGIN
					
						UPDATE Teams SET DeletedDate = NULL,
							UpdatedBy = @updatedby
							WHERE CompanyCode = @companycode
							AND TeamCode = @teamcode
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

