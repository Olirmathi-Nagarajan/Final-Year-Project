module tb_APA_Filter;

    // Testbench signals
    reg clk;
    reg reset;
    reg [15:0] noisy_signal;
    reg [15:0] desired_signal;
    wire [15:0] filtered_signal;
    wire [15:0] weight;
    
    // Integer to read from file
    integer noisy_file, desired_file, i;
    reg [15:0] input_signal;
    reg [15:0] target_signal;

    // Instantiate the APA_Filter module
    APA_Filter uut (
        .clk(clk),
        .reset(reset),
        .noisy_signal(noisy_signal),
        .desired_signal(desired_signal),
        .filtered_signal(filtered_signal),
        .weight(weight)
        );

    // Clock generation
    always begin
        clk = 0;
        #5 clk = 1;   // Period = 10 time units
        #5 clk = 0;
    end

   
        // Open the noisy signal text file for reading
        noisy_file = $fopen("chb01_05_channel_1.txt", "r");
        desired_file = $fopen("chb01_15_channel_1.txt", "r");

        if (noisy_file && desired_file) begin
       // Read each line of the noisy signal data and apply to the filter

            for (i = 0; i < 1000; i = i + 1) begin  // Reading first 1000 samples
                // Read the noisy signal from chb01_05_channel_1.txt

                $fscanf(noisy_file, "%d\n", input_signal);
                noisy_signal = input_signal;   // Apply the noisy signal to the filter

               
            $fclose(noisy_file);
            $fclose(desired_file);
        end else begin
            $display("Error opening files!");
        end

        // Finish the simulation after reading the data
        #100 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("At time %t, Noisy: %d, Desired: %d, Filtered: %d, Weight: %d",
                 $time, noisy_signal, desired_signal, filtered_signal, weight);
    end
endmodule
