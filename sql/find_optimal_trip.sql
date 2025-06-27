-- Stores procedure that uses a shortest path algorithm to compute an optimal trip between two zones

ALTER PROCEDURE FindOptimalTrip
    @StartID INT,
    @EndID INT
AS
BEGIN
    -- Table full of nodes whose distances are known
    DECLARE @NodesExplored Table (
        zone_id INT PRIMARY KEY,
        total_dist FLOAT,
        total_time FLOAT
    )

    INSERT INTO @NodesExplored (zone_id, total_dist, total_time)
    VALUES (@StartID, 0, 0);

    DECLARE @LoopCt INT = 0;

    WHILE (@LoopCt < 265)
    BEGIN

        DECLARE @NEIGHBORS TABLE (
            prev_node INT,
            next_node INT,
            total_time FLOAT,
            total_dist FLOAT
        );

        -- Find new neighbors of all explored nodes
        INSERT INTO @NEIGHBORS (prev_node, next_node, total_dist, total_time)
        SELECT ne.zone_id, tg.end_node, ne.total_dist + tg.avg_dist, ne.total_time + tg.avg_time
        FROM @NodesExplored ne
        JOIN TripGraph tg
        ON ne.zone_id = tg.start_node
            AND tg.end_node NOT IN (SELECT zone_id FROM @NodesExplored);

        -- check that the rest of the graph is reachable
        IF NOT EXISTS (SELECT 1 FROM @Neighbors)
        BEGIN
            -- No path exists, return NULL
            SELECT NULL;
            RETURN
        END

        -- Find the next closest node to the source
        DECLARE @MinEntry TABLE (
            zone_id INT PRIMARY KEY,
            total_dist FLOAT,
            total_time FLOAT
        )

        INSERT INTO @MinEntry (zone_id, total_dist, total_time)
        SELECT TOP 1 next_node, total_dist, total_time
        FROM @Neighbors
        ORDER BY total_time ASC;


        -- Check if target zone was reached
        If (
            SELECT TOP 1 zone_id
            FROM @MinEntry
        ) = @EndID
        BEGIN
            SELECT @StartID as start_zone, @EndID as end_zone, total_dist, total_time
            FROM @MinEntry;
            RETURN
        END

        -- 
        INSERT INTO @NodesExplored (zone_id, total_dist, total_time)
        SELECT * FROM @MinEntry;

        -- Protect from infinite loop
        SET @LoopCt = @LoopCt + 1;

        -- Clear tables after each iteration
        DELETE FROM @Neighbors;
        DELETE FROM @MinEntry;

    END

END

-- TEST
EXEC FindOptimalTrip @StartID = 34, @EndID = 52;