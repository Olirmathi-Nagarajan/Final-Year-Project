    module APA_Filter (
    input wire clk,                // Clock input
    input wire reset,              // Reset signal
    input wire [15:0] noisy_signal,  // Noisy EEG signal
    input wire [15:0] desired_signal,  // Desired clean EEG signal
    output reg [15:0] filtered_signal, // Output filtered EEG signal
    output reg [15:0] weight        // Adaptive filter weight
);
    // Parameters for APA
    parameter mu = 16'd10;            // Step size (learning rate)
    parameter M = 16;                 // Number of taps (filter length)
    
    // Internal signals
    reg [15:0] x [0:M-1];           // Delay line
    reg [15:0] y;                   // Filter output
    reg [15:0] e;                   // Error signal (desired - output)
    reg [15:0] w [0:M-1];           // Weights

    // Initialize weights to zero at reset
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the filter weights and delay line
            for (i = 0; i < M; i = i + 1) begin
                w[i] <= 16'b0;
                x[i] <= 16'b0;
        end    
        
        else begin
            // Shift the delay line
            for (i = M-1; i > 0; i = i - 1) begin
                x[i] <= x[i-1];
            end
            x[0] <= noisy_signal;  // New sample

            // Compute the filter output (y)
            y = 16'b0;
            for (i = 0; i < M; i = i + 1) begin
                y = y + (w[i] * x[i]);  // Multiply and accumulate
            end

            // Compute the error (desired signal - output)
            e = desired_signal - y;

            // Update the weights using APA rule
            for (i = 0; i < M; i = i + 1) begin
                w[i] <= w[i] + (mu * e * x[i]);  // Weight update
            end

            // Output the filtered signal and the weight
            filtered_signal <= y;
            weight <= w[M-1];  // Output the last weight (can be monitored)
        end
    end
endmodule
