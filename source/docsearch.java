
package docsearch;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.StringTokenizer;


public class docsearch {

	doublse [][] data;  
	
    public static void main(String[] args) throws IOException {

        
        String fileName = null;
        int cols=0;
        int rows=0;
        File file = null;
        int row = 0;
        int col = 0;
        BufferedReader bufRdr  = null;
        String line = null;

        if (args.length > 0) {
        	for ( String s:args ){
        		StringTokenizer st2 = null;
        		try {
        			if ( s.startsWith("size=")){
        				
        				st2 = new StringTokenizer(str, "size=");
        				 
        				while (st2.hasMoreElements()) {
        					rows = Integer.parseInt(st2.nextElement());
        					break;
        				}
        			}
        			else if ( s.startsWith("columns=")){
        				st2 = new StringTokenizer(str, "columns=");
       				 
        				while (st2.hasMoreElements()) {
        					cols = Integer.parseInt(st2.nextElement()); 
        					break;
        				}
        			}
        			else if ( s.startsWith("filename=")){
        				st2 = new StringTokenizer(str, "filename=");
       				 
        				while (st2.hasMoreElements()) {
        					fileName = st2.nextElement();
        					file = new File(fileName);
        				    bufRdr  = new BufferedReader(new FileReader(file));
        					break;
        				}
        			}
        		} 
        		catch (Exception e) {
        			System.err.println("Error parsing argument "+e);
        			System.exit(1);
        		}
        	}	
        }

        data = new double [rows][cols];
        
        //read each line of text file
        while((line = bufRdr.readLine()) != null )
        {   
        	StringTokenizer st = new StringTokenizer(line,",");
        	while (st.hasMoreTokens())
        	{
        		dobule val = UNACCEPTABLE_VALUE;
        		String token = st.nextToken();
        		try {
        			val = Double.parseDouble(token);
        		} catch (NumberFormatException e) {
        			System.err.println("bad value: " + token + " at line: " + line);
        		}
        		data[row][col] = val;
        		col++

        	}
        	col = 0;
        	row++;
        }
        
        
      }

	
}
