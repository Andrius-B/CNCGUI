import geomerative.*;
class svgParser{
  RShape group;
  RPoint[] points;
  ArrayList<Command> comms;
  public svgParser(){
  }
  public svgParser(File file){
     group = RG.loadShape(file.getAbsolutePath());
     RG.setPolygonizer(RG.UNIFORMLENGTH);
     RG.setPolygonizerLength(7);//how many pixels between the path points
     RPoint last = new RPoint();
     comms = new ArrayList<Command>(0);
     for(int c = 0; c<group.countChildren();c++){
       //for every child index c:
       if(group.children[c].getPoints()!=null){
         points = group.children[c].getPoints();
         //assume the pen is lifted beforehand
         comms.add(new Command((byte)'m', (short)points[0].x, (short)points[0].y));//casting because the compiler is a little baby
         last = points[0];
         //comms.add(new Command((byte)'l', (byte)'d'));//move pen to begining pos and lower it
         for(int i = 1; i<points.length;i++){
           comms.add(new Command((byte)'m', (short)(last.x - points[i].x), (short)(last.y - points[i].y)));// keep moving the pen along the childs path
           last = points[i];
         }
         //comms.add(new Command((byte)'l', (byte)'u')); // lift the pen after finishing this shape
       }
     }
  }
  
  public ArrayList<Command> getPath(){
    return comms;
  }
  
}