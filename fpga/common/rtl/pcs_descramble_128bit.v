//Generated by tools @ 2024/7/16 22:10:56
//Ploy:0x400008000000001
//Ploy:x58+x39+1
//input reverse:false
//output reverse:false
//init value:0x2aaaaaaaaaaaaaa
//output xor value:0x0000000000000
`timescale 1ns/1ps
module pcs_descramble_128bit
(
    input                    clk_sys ,
    input                    rst_sys ,
    input         [127:0]    data_in ,
    input                    sync_in ,
    output reg    [127:0]    data_out,
    output reg               sync_out
);
localparam    CRC_INIT_VALUE=    58'h2aaaaaaaaaaaaaa;
wire    [57:0]    crc_next;
wire    [127:0]    data_in_buf;
wire    [127:0]    data_out_w;
wire    [127:0]    data_out_buf;
reg    [57:0]    crc_shift;
assign    data_in_buf=data_in;
assign    data_out_w=data_out_buf;
assign    data_out_buf[0]=crc_shift[38]^crc_shift[57]^data_in_buf[0];
assign    data_out_buf[1]=crc_shift[37]^crc_shift[56]^data_in_buf[1];
assign    data_out_buf[2]=crc_shift[36]^crc_shift[55]^data_in_buf[2];
assign    data_out_buf[3]=crc_shift[35]^crc_shift[54]^data_in_buf[3];
assign    data_out_buf[4]=crc_shift[34]^crc_shift[53]^data_in_buf[4];
assign    data_out_buf[5]=crc_shift[33]^crc_shift[52]^data_in_buf[5];
assign    data_out_buf[6]=crc_shift[32]^crc_shift[51]^data_in_buf[6];
assign    data_out_buf[7]=crc_shift[31]^crc_shift[50]^data_in_buf[7];
assign    data_out_buf[8]=crc_shift[30]^crc_shift[49]^data_in_buf[8];
assign    data_out_buf[9]=crc_shift[29]^crc_shift[48]^data_in_buf[9];
assign    data_out_buf[10]=crc_shift[28]^crc_shift[47]^data_in_buf[10];
assign    data_out_buf[11]=crc_shift[27]^crc_shift[46]^data_in_buf[11];
assign    data_out_buf[12]=crc_shift[26]^crc_shift[45]^data_in_buf[12];
assign    data_out_buf[13]=crc_shift[25]^crc_shift[44]^data_in_buf[13];
assign    data_out_buf[14]=crc_shift[24]^crc_shift[43]^data_in_buf[14];
assign    data_out_buf[15]=crc_shift[23]^crc_shift[42]^data_in_buf[15];
assign    data_out_buf[16]=crc_shift[22]^crc_shift[41]^data_in_buf[16];
assign    data_out_buf[17]=crc_shift[21]^crc_shift[40]^data_in_buf[17];
assign    data_out_buf[18]=crc_shift[20]^crc_shift[39]^data_in_buf[18];
assign    data_out_buf[19]=crc_shift[19]^crc_shift[38]^data_in_buf[19];
assign    data_out_buf[20]=crc_shift[18]^crc_shift[37]^data_in_buf[20];
assign    data_out_buf[21]=crc_shift[17]^crc_shift[36]^data_in_buf[21];
assign    data_out_buf[22]=crc_shift[16]^crc_shift[35]^data_in_buf[22];
assign    data_out_buf[23]=crc_shift[15]^crc_shift[34]^data_in_buf[23];
assign    data_out_buf[24]=crc_shift[14]^crc_shift[33]^data_in_buf[24];
assign    data_out_buf[25]=crc_shift[13]^crc_shift[32]^data_in_buf[25];
assign    data_out_buf[26]=crc_shift[12]^crc_shift[31]^data_in_buf[26];
assign    data_out_buf[27]=crc_shift[11]^crc_shift[30]^data_in_buf[27];
assign    data_out_buf[28]=crc_shift[10]^crc_shift[29]^data_in_buf[28];
assign    data_out_buf[29]=crc_shift[9]^crc_shift[28]^data_in_buf[29];
assign    data_out_buf[30]=crc_shift[8]^crc_shift[27]^data_in_buf[30];
assign    data_out_buf[31]=crc_shift[7]^crc_shift[26]^data_in_buf[31];
assign    data_out_buf[32]=crc_shift[6]^crc_shift[25]^data_in_buf[32];
assign    data_out_buf[33]=crc_shift[5]^crc_shift[24]^data_in_buf[33];
assign    data_out_buf[34]=crc_shift[4]^crc_shift[23]^data_in_buf[34];
assign    data_out_buf[35]=crc_shift[3]^crc_shift[22]^data_in_buf[35];
assign    data_out_buf[36]=crc_shift[2]^crc_shift[21]^data_in_buf[36];
assign    data_out_buf[37]=crc_shift[1]^crc_shift[20]^data_in_buf[37];
assign    data_out_buf[38]=crc_shift[0]^crc_shift[19]^data_in_buf[38];
assign    data_out_buf[39]=crc_shift[18]^data_in_buf[0]^data_in_buf[39];
assign    data_out_buf[40]=crc_shift[17]^data_in_buf[1]^data_in_buf[40];
assign    data_out_buf[41]=crc_shift[16]^data_in_buf[2]^data_in_buf[41];
assign    data_out_buf[42]=crc_shift[15]^data_in_buf[3]^data_in_buf[42];
assign    data_out_buf[43]=crc_shift[14]^data_in_buf[4]^data_in_buf[43];
assign    data_out_buf[44]=crc_shift[13]^data_in_buf[5]^data_in_buf[44];
assign    data_out_buf[45]=crc_shift[12]^data_in_buf[6]^data_in_buf[45];
assign    data_out_buf[46]=crc_shift[11]^data_in_buf[7]^data_in_buf[46];
assign    data_out_buf[47]=crc_shift[10]^data_in_buf[8]^data_in_buf[47];
assign    data_out_buf[48]=crc_shift[9]^data_in_buf[9]^data_in_buf[48];
assign    data_out_buf[49]=crc_shift[8]^data_in_buf[10]^data_in_buf[49];
assign    data_out_buf[50]=crc_shift[7]^data_in_buf[11]^data_in_buf[50];
assign    data_out_buf[51]=crc_shift[6]^data_in_buf[12]^data_in_buf[51];
assign    data_out_buf[52]=crc_shift[5]^data_in_buf[13]^data_in_buf[52];
assign    data_out_buf[53]=crc_shift[4]^data_in_buf[14]^data_in_buf[53];
assign    data_out_buf[54]=crc_shift[3]^data_in_buf[15]^data_in_buf[54];
assign    data_out_buf[55]=crc_shift[2]^data_in_buf[16]^data_in_buf[55];
assign    data_out_buf[56]=crc_shift[1]^data_in_buf[17]^data_in_buf[56];
assign    data_out_buf[57]=crc_shift[0]^data_in_buf[18]^data_in_buf[57];
assign    data_out_buf[58]=data_in_buf[0]^data_in_buf[19]^data_in_buf[58];
assign    data_out_buf[59]=data_in_buf[1]^data_in_buf[20]^data_in_buf[59];
assign    data_out_buf[60]=data_in_buf[2]^data_in_buf[21]^data_in_buf[60];
assign    data_out_buf[61]=data_in_buf[3]^data_in_buf[22]^data_in_buf[61];
assign    data_out_buf[62]=data_in_buf[4]^data_in_buf[23]^data_in_buf[62];
assign    data_out_buf[63]=data_in_buf[5]^data_in_buf[24]^data_in_buf[63];
assign    data_out_buf[64]=data_in_buf[6]^data_in_buf[25]^data_in_buf[64];
assign    data_out_buf[65]=data_in_buf[7]^data_in_buf[26]^data_in_buf[65];
assign    data_out_buf[66]=data_in_buf[8]^data_in_buf[27]^data_in_buf[66];
assign    data_out_buf[67]=data_in_buf[9]^data_in_buf[28]^data_in_buf[67];
assign    data_out_buf[68]=data_in_buf[10]^data_in_buf[29]^data_in_buf[68];
assign    data_out_buf[69]=data_in_buf[11]^data_in_buf[30]^data_in_buf[69];
assign    data_out_buf[70]=data_in_buf[12]^data_in_buf[31]^data_in_buf[70];
assign    data_out_buf[71]=data_in_buf[13]^data_in_buf[32]^data_in_buf[71];
assign    data_out_buf[72]=data_in_buf[14]^data_in_buf[33]^data_in_buf[72];
assign    data_out_buf[73]=data_in_buf[15]^data_in_buf[34]^data_in_buf[73];
assign    data_out_buf[74]=data_in_buf[16]^data_in_buf[35]^data_in_buf[74];
assign    data_out_buf[75]=data_in_buf[17]^data_in_buf[36]^data_in_buf[75];
assign    data_out_buf[76]=data_in_buf[18]^data_in_buf[37]^data_in_buf[76];
assign    data_out_buf[77]=data_in_buf[19]^data_in_buf[38]^data_in_buf[77];
assign    data_out_buf[78]=data_in_buf[20]^data_in_buf[39]^data_in_buf[78];
assign    data_out_buf[79]=data_in_buf[21]^data_in_buf[40]^data_in_buf[79];
assign    data_out_buf[80]=data_in_buf[22]^data_in_buf[41]^data_in_buf[80];
assign    data_out_buf[81]=data_in_buf[23]^data_in_buf[42]^data_in_buf[81];
assign    data_out_buf[82]=data_in_buf[24]^data_in_buf[43]^data_in_buf[82];
assign    data_out_buf[83]=data_in_buf[25]^data_in_buf[44]^data_in_buf[83];
assign    data_out_buf[84]=data_in_buf[26]^data_in_buf[45]^data_in_buf[84];
assign    data_out_buf[85]=data_in_buf[27]^data_in_buf[46]^data_in_buf[85];
assign    data_out_buf[86]=data_in_buf[28]^data_in_buf[47]^data_in_buf[86];
assign    data_out_buf[87]=data_in_buf[29]^data_in_buf[48]^data_in_buf[87];
assign    data_out_buf[88]=data_in_buf[30]^data_in_buf[49]^data_in_buf[88];
assign    data_out_buf[89]=data_in_buf[31]^data_in_buf[50]^data_in_buf[89];
assign    data_out_buf[90]=data_in_buf[32]^data_in_buf[51]^data_in_buf[90];
assign    data_out_buf[91]=data_in_buf[33]^data_in_buf[52]^data_in_buf[91];
assign    data_out_buf[92]=data_in_buf[34]^data_in_buf[53]^data_in_buf[92];
assign    data_out_buf[93]=data_in_buf[35]^data_in_buf[54]^data_in_buf[93];
assign    data_out_buf[94]=data_in_buf[36]^data_in_buf[55]^data_in_buf[94];
assign    data_out_buf[95]=data_in_buf[37]^data_in_buf[56]^data_in_buf[95];
assign    data_out_buf[96]=data_in_buf[38]^data_in_buf[57]^data_in_buf[96];
assign    data_out_buf[97]=data_in_buf[39]^data_in_buf[58]^data_in_buf[97];
assign    data_out_buf[98]=data_in_buf[40]^data_in_buf[59]^data_in_buf[98];
assign    data_out_buf[99]=data_in_buf[41]^data_in_buf[60]^data_in_buf[99];
assign    data_out_buf[100]=data_in_buf[42]^data_in_buf[61]^data_in_buf[100];
assign    data_out_buf[101]=data_in_buf[43]^data_in_buf[62]^data_in_buf[101];
assign    data_out_buf[102]=data_in_buf[44]^data_in_buf[63]^data_in_buf[102];
assign    data_out_buf[103]=data_in_buf[45]^data_in_buf[64]^data_in_buf[103];
assign    data_out_buf[104]=data_in_buf[46]^data_in_buf[65]^data_in_buf[104];
assign    data_out_buf[105]=data_in_buf[47]^data_in_buf[66]^data_in_buf[105];
assign    data_out_buf[106]=data_in_buf[48]^data_in_buf[67]^data_in_buf[106];
assign    data_out_buf[107]=data_in_buf[49]^data_in_buf[68]^data_in_buf[107];
assign    data_out_buf[108]=data_in_buf[50]^data_in_buf[69]^data_in_buf[108];
assign    data_out_buf[109]=data_in_buf[51]^data_in_buf[70]^data_in_buf[109];
assign    data_out_buf[110]=data_in_buf[52]^data_in_buf[71]^data_in_buf[110];
assign    data_out_buf[111]=data_in_buf[53]^data_in_buf[72]^data_in_buf[111];
assign    data_out_buf[112]=data_in_buf[54]^data_in_buf[73]^data_in_buf[112];
assign    data_out_buf[113]=data_in_buf[55]^data_in_buf[74]^data_in_buf[113];
assign    data_out_buf[114]=data_in_buf[56]^data_in_buf[75]^data_in_buf[114];
assign    data_out_buf[115]=data_in_buf[57]^data_in_buf[76]^data_in_buf[115];
assign    data_out_buf[116]=data_in_buf[58]^data_in_buf[77]^data_in_buf[116];
assign    data_out_buf[117]=data_in_buf[59]^data_in_buf[78]^data_in_buf[117];
assign    data_out_buf[118]=data_in_buf[60]^data_in_buf[79]^data_in_buf[118];
assign    data_out_buf[119]=data_in_buf[61]^data_in_buf[80]^data_in_buf[119];
assign    data_out_buf[120]=data_in_buf[62]^data_in_buf[81]^data_in_buf[120];
assign    data_out_buf[121]=data_in_buf[63]^data_in_buf[82]^data_in_buf[121];
assign    data_out_buf[122]=data_in_buf[64]^data_in_buf[83]^data_in_buf[122];
assign    data_out_buf[123]=data_in_buf[65]^data_in_buf[84]^data_in_buf[123];
assign    data_out_buf[124]=data_in_buf[66]^data_in_buf[85]^data_in_buf[124];
assign    data_out_buf[125]=data_in_buf[67]^data_in_buf[86]^data_in_buf[125];
assign    data_out_buf[126]=data_in_buf[68]^data_in_buf[87]^data_in_buf[126];
assign    data_out_buf[127]=data_in_buf[69]^data_in_buf[88]^data_in_buf[127];
assign    crc_next[0]=data_in_buf[127];
assign    crc_next[1]=data_in_buf[126];
assign    crc_next[2]=data_in_buf[125];
assign    crc_next[3]=data_in_buf[124];
assign    crc_next[4]=data_in_buf[123];
assign    crc_next[5]=data_in_buf[122];
assign    crc_next[6]=data_in_buf[121];
assign    crc_next[7]=data_in_buf[120];
assign    crc_next[8]=data_in_buf[119];
assign    crc_next[9]=data_in_buf[118];
assign    crc_next[10]=data_in_buf[117];
assign    crc_next[11]=data_in_buf[116];
assign    crc_next[12]=data_in_buf[115];
assign    crc_next[13]=data_in_buf[114];
assign    crc_next[14]=data_in_buf[113];
assign    crc_next[15]=data_in_buf[112];
assign    crc_next[16]=data_in_buf[111];
assign    crc_next[17]=data_in_buf[110];
assign    crc_next[18]=data_in_buf[109];
assign    crc_next[19]=data_in_buf[108];
assign    crc_next[20]=data_in_buf[107];
assign    crc_next[21]=data_in_buf[106];
assign    crc_next[22]=data_in_buf[105];
assign    crc_next[23]=data_in_buf[104];
assign    crc_next[24]=data_in_buf[103];
assign    crc_next[25]=data_in_buf[102];
assign    crc_next[26]=data_in_buf[101];
assign    crc_next[27]=data_in_buf[100];
assign    crc_next[28]=data_in_buf[99];
assign    crc_next[29]=data_in_buf[98];
assign    crc_next[30]=data_in_buf[97];
assign    crc_next[31]=data_in_buf[96];
assign    crc_next[32]=data_in_buf[95];
assign    crc_next[33]=data_in_buf[94];
assign    crc_next[34]=data_in_buf[93];
assign    crc_next[35]=data_in_buf[92];
assign    crc_next[36]=data_in_buf[91];
assign    crc_next[37]=data_in_buf[90];
assign    crc_next[38]=data_in_buf[89];
assign    crc_next[39]=data_in_buf[88];
assign    crc_next[40]=data_in_buf[87];
assign    crc_next[41]=data_in_buf[86];
assign    crc_next[42]=data_in_buf[85];
assign    crc_next[43]=data_in_buf[84];
assign    crc_next[44]=data_in_buf[83];
assign    crc_next[45]=data_in_buf[82];
assign    crc_next[46]=data_in_buf[81];
assign    crc_next[47]=data_in_buf[80];
assign    crc_next[48]=data_in_buf[79];
assign    crc_next[49]=data_in_buf[78];
assign    crc_next[50]=data_in_buf[77];
assign    crc_next[51]=data_in_buf[76];
assign    crc_next[52]=data_in_buf[75];
assign    crc_next[53]=data_in_buf[74];
assign    crc_next[54]=data_in_buf[73];
assign    crc_next[55]=data_in_buf[72];
assign    crc_next[56]=data_in_buf[71];
assign    crc_next[57]=data_in_buf[70];
always@(posedge clk_sys or posedge rst_sys)
begin
    if(rst_sys==1'b1)
        crc_shift<=CRC_INIT_VALUE;
    else
        crc_shift<=crc_next;
end
always@(posedge clk_sys or posedge rst_sys)
begin
    if(rst_sys==1'b1)
        data_out<=128'd0;
    else
        data_out<=data_out_w;
end
always@(posedge clk_sys or posedge rst_sys)
begin
    if(rst_sys==1'b1)
        sync_out<=1'd0;
    else
        sync_out<=sync_in;
end
endmodule
