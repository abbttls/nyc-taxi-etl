-- Create a lookup table for payment_type codes in the NYC Yellow Taxi dataset
CREATE TABLE dbo.payment_type_lookup (
    payment_type INT PRIMARY KEY,
    payment_label VARCHAR(32) NOT NULL
);

-- Insert standard payment type codes and labels
INSERT INTO dbo.payment_type_lookup (payment_type, payment_label) VALUES
    (1, 'Credit card'),
    (2, 'Cash'),
    (3, 'No charge'),
    (4, 'Dispute'),
    (5, 'Unknown'),
    (6, 'Voided trip');
