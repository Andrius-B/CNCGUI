import processing.serial.*;
class Command{//bytes represented in refrence to ascii chars for readability
  byte type; //'m'for move 'l' for lift 'r' for reset
  byte direction; //'u' or 'd' for up or down
  short x, y;
  private String commandStr = "";
  public Command(){
    type = 'l'; //default is lift
    direction = 'u'; // default is up
  }
  public Command(byte type){
     this.type = type;
  }
  public Command(byte type, byte direction){
    this.type = type;
    this.direction = direction;
  }
  public Command(byte type, short x, short y){
    this.type = type;
    this.x = x;
    this.y = y;
  }
  public void print(){
    println(""+(char)type+' '+x+' '+y+'\n');
  }
  public boolean sendCommand(Serial port){
    if(type=='l'){
      if(direction=='u')port.write("lu");
      if(direction=='d')port.write("ld");  
    }else if(type == 'r'){
      port.write(""+type);
    }else if(type == 'm'){
      commandStr = "";
      commandStr = commandStr+"m "+int(x)+' '+int(y)+'\n';
      port.write(commandStr);
      
    }
    return true;
  }
  /*public boolean sendCommand(Serial port){ //bitwise doesnt work yet
    if(type=='l'){
      port.write(type+direction);
    }else if(type == 'r'){
      port.write(type);
    }else if(type == 'm'){
      port.write(type);
      byte most, least;
      short number = x;
      for(int i = 0; i<2; i++){
        if(i>0){number=y;}//ater x is sent set number to y and send it
        least = byte(number & 0x00FF); // bitmask to get the least significant byte
        most = byte((number >> 8) & 0x00FF); //rightshift by a byte and bitmask it
        port.write(most);
        port.write(least);
      }
      
    }
    return true;
  }*/
}