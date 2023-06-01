module predictor (input wire request,input wire result,input wire clk,input wire taken,output reg prediction);

  reg [1:0] counter = 2'b00; // Initialize the counter to the Weakly Taken state

  always @(posedge clk) begin
    if (request) begin
      // Branch outcome update
      if (result == taken) begin
        case (counter)
          2'b11: counter <= 2'b11; // Saturate at Strongly Taken state
          2'b10: counter <= 2'b11; // Move to Strongly Taken state
          2'b01: counter <= 2'b10; // Move to Weakly Not Taken state
          2'b00: counter <= 2'b01; // Move to Weakly Taken state
        endcase
      end else begin
        case (counter)
          2'b11: counter <= 2'b10; // Move to Weakly Taken state
          2'b10: counter <= 2'b00; // Move to Strongly Not Taken state
          2'b01: counter <= 2'b00; // Move to Strongly Not Taken state
          2'b00: counter <= 2'b00; // Saturate at Strongly Not Taken state
        endcase
      end
    end
  end

  always @(posedge clk) begin
    // Predict the branch outcome based on the counter state
    if (request) begin
      case (counter)
        2'b11: prediction <= 1; // Strongly Taken or Weakly Taken
        2'b10: prediction <= 1; // Weakly Not Taken
        2'b01: prediction <= 0; // Weakly Taken
        2'b00: prediction <= 0; // Strongly Not Taken
      endcase
    end
  end

endmodule
