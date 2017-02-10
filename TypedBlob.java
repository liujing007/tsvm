package typedBlob;

import java.sql.*;

/**
 * A class that deals with blobs (Binary Large OBjects, a possible field type in a database) that contain
 * a series of variables of a specific type (e.g. int or double).
 */
public class TypedBlob {

  /**
   * @param blob The blob to be processed (e.g. converted to an array)
   * REMARK: the length of the blob (a long) is cast to an int because blob.getBytes() requires an integer.
   *  (beware that this might cause problems with VERY large blobs..., but if sun's own method getBytes() 
   *   only works with blobs with as max size the max integer value, this will be no prob I suppose...
   */
  public TypedBlob(Blob blob) throws SQLException {
    try {
      $blobLength= (int)blob.length();
      $blobByte= blob.getBytes(1,$blobLength);
    } catch (SQLException e) {
      throw e;
    }
  }
 
  /**
   * Return a reference to an array of integers containing all integers in the blob.
   * @return A reference to an array of integers containing all integers in the blob.
   */
  public int[] toIntArray() {
    int bits,i,j;
    int[] int_arr= new int[$blobLength/4];		// An integer consists of 4 bytes.
    for (i=0;i<int_arr.length;i++) {
      int_arr[i]=0;

      // In the blob, the LSByte comes first and the MSB last (but for the separate bytes counts MSb..LSb !)
      for (j=3;j>=0;j--) {
        bits=0;
        bits= $blobByte[4*i+j]>=0 ? (bits | $blobByte[4*i+j]) : ((bits | ($blobByte[4*i+j] & ((byte)127))) +128);
	/*REMARK: if the sign bit of the byte is set (>127), then there is a special case.
         Setting the sign bit to zero, ORing that byte with the empty integer, and afterwards adding 128 back
         to the integer, makes sure java doesn't set the sign bit of the integer itself. (what it otherwise
         illogically seems to do)*/


        bits= (bits << (j*8));		// Shifting left over 24, 16 or 8 bits.
        int_arr[i]= (int_arr[i] | bits);
      }
    }
    return (int_arr);
  }

  /**
   * Return a reference to an array of floats containing all floats in the blob.
   * @return A reference to an array of floats containing all floats in the blob.
   */
  public float[] toFloatArray() {
    int bits,bits2;
    int i,j;
    float[] float_arr= new float[$blobLength/4];		// A float consists of 4 bytes
    for (i=0;i<float_arr.length;i++) {
      bits2=0;

      // In the blob, the LSByte comes first and the MSB last (but for the separate bytes counts MSb..LSb !)
      for (j=3;j>=0;j--) {
        bits=0;
        bits= $blobByte[4*i+j]>=0 ? (bits | $blobByte[4*i+j]) : ((bits | ($blobByte[4*i+j] & ((byte)127))) +128);
	//REMARK: if the sign bit of the byte is set (>127), then there is a special case.
        //Setting the sign bit to zero, ORing that byte with the empty int, and afterwards adding 128 back
        //to the int, makes sure java doesn't set the sign bit of the int itself. (what it otherwise
        //illogically seems to do)

        bits= (bits << (j*8));		// Shifting left over 24,16 or 8 bits.
        bits2= (bits2 | bits);
      }
      float_arr[i]= java.lang.Float.intBitsToFloat(bits2);
    }
    return (float_arr);
  }

  /**
   * Return a reference to an array of doubles containing all doubles in the blob.
   * @return A reference to an array of doubles containing all doubles in the blob.
   */
  public double[] toDoubleArray() {
    long bits,bits2;
    int i,j;
    double[] double_arr= new double[$blobLength/8];		// A double consists of 8 bytes?
    for (i=0;i<double_arr.length;i++) {
      bits2=0;

      // In the blob, the LSByte comes first and the MSB last (but for the separate bytes counts MSb..LSb !)
      for (j=7;j>=0;j--) {
        bits=0;
        bits= $blobByte[8*i+j]>=0 ? (bits | $blobByte[8*i+j]) : ((bits | ($blobByte[8*i+j] & ((byte)127))) +128);
	/*REMARK: if the sign bit of the byte is set (>127), then there is a special case.
         Setting the sign bit to zero, ORing that byte with the empty long, and afterwards adding 128 back
         to the long, makes sure java doesn't set the sign bit of the long itself. (what it otherwise
         illogically seems to do)*/

        bits= (bits << (j*8));		// Shifting left over multiples of 8 bits.
        bits2= (bits2 | bits);
      }
      double_arr[i]= java.lang.Double.longBitsToDouble(bits2);
    }
    return (double_arr);
  }

  /**
   * Return a byte array containing all bytes in the blob.
   * @return A byte array containing all bytes in the blob.
   */
  public byte[] getByteArray(){
    return ($blobByte);
  }

  /**
   * Return the number of bytes in the blob.
   * @return The number of bytes in the blob.
   */
  public int getNrOfBytes(){
    return ($blobLength);
  }

  /**
   * Return the number of ints that fit in the blob.
   * @return The number of ints that fit in the blob.
   */
  public int getNrOfInts(){
    return ($blobLength/4);
  }

  /**
   * Return the number of floats that fit in the blob.
   * @return The number of floats that fit in the blob.
   */
  public int getNrOfFloats(){
    return ($blobLength/4);
  }

  /**
   * Return the number of doubles that fit in the blob.
   * @return The number of doubles that fit in the blob.
   */
  public int getNrOfDoubles(){
    return ($blobLength/8);
  }

  /**
   * An array containing the bytes in the blob.
   */
  private byte[] $blobByte;

  /**
   * The length of the blob (# bytes).
   */
  private int $blobLength;
}