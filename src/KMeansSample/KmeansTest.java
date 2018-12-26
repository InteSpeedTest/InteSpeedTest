package KMeansSample;

import java.util.ArrayList;

public class KmeansTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		KMeans k = new KMeans(10);
		ArrayList<double[]> dataSet = new ArrayList<double[]>();

		dataSet.add(new double[] { 1, 2 });
		dataSet.add(new double[] { 3, 3 });
		dataSet.add(new double[] { 3, 4 });
		dataSet.add(new double[] { 5, 6 });
		dataSet.add(new double[] { 8, 9 });
		dataSet.add(new double[] { 4, 5 });
		dataSet.add(new double[] { 6, 4 });
		dataSet.add(new double[] { 3, 9 });
		dataSet.add(new double[] { 5, 9 });
		dataSet.add(new double[] { 4, 2 });
		dataSet.add(new double[] { 1, 9 });
		dataSet.add(new double[] { 7, 8 });

		k.setDataSet(dataSet);
		k.execute();
		ArrayList<ArrayList<double[]>> cluster = k.getCluster();
		for (int i = 0; i < cluster.size(); i++) {
			k.printDataArray(cluster.get(i), "cluster[" + i + "]");
		}
	}

}
