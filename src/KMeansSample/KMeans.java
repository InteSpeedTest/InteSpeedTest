package KMeansSample;

import java.util.ArrayList;
import java.util.Random;

public class KMeans {
	private int k;// # of clusters
	private int m;// # of iterations
	private int dataSetLength;// # of data
	private ArrayList<double[]> dataSet;
	private ArrayList<double[]> center;
	private ArrayList<ArrayList<double[]>> cluster;
	private ArrayList<Double> jc;// error rate
	private Random random;

	// Original dataset
	public void setDataSet(ArrayList<double[]> dataSet) {
		this.dataSet = dataSet;
	}

	// return final clusters
	public ArrayList<ArrayList<double[]>> getCluster() {
		return cluster;
	}

	// set k
	public KMeans(int k) {
		if (k <= 0) {
			k = 1;
		}
		this.k = k;
	}

	// initialization
	private void init() {
		m = 0;
		random = new Random();
		if (dataSet == null || dataSet.size() == 0) {
			initDataSet();
		}
		dataSetLength = dataSet.size();
		if (k > dataSetLength) {
			k = dataSetLength;
		}
		center = initCenters();
		cluster = initCluster();
		jc = new ArrayList<Double>();
	}

	// internal testing set
	private void initDataSet() {
		dataSet = new ArrayList<double[]>();
		double[][] dataSetArray = new double[][] { { 8, 2 }, { 3, 4 }, { 2, 5 }, { 4, 2 }, { 7, 3 }, { 6, 2 }, { 4, 7 },
				{ 6, 3 }, { 5, 3 }, { 6, 3 }, { 6, 9 }, { 1, 6 }, { 3, 9 }, { 4, 1 }, { 8, 6 } };

		for (int i = 0; i < dataSetArray.length; i++) {
			dataSet.add(dataSetArray[i]);
		}
	}

	// initialize center
	private ArrayList<double[]> initCenters() {
		ArrayList<double[]> center = new ArrayList<double[]>();
		int[] randoms = new int[k];
		boolean flag;
		int temp = random.nextInt(dataSetLength);
		randoms[0] = temp;
		for (int i = 1; i < k; i++) {
			flag = true;
			while (flag) {
				temp = random.nextInt(dataSetLength);
				int j = 0;
				while (j < i) {
					if (temp == randoms[j]) {
						break;
					}
					j++;
				}
				if (j == i) {
					flag = false;
				}

			}
			randoms[i] = temp;
		}

		for (int i = 0; i < k; i++) {
			center.add(dataSet.get(randoms[i])); // random center
		}
		return center;
	}

	// initialize cluster
	private ArrayList<ArrayList<double[]>> initCluster() {
		ArrayList<ArrayList<double[]>> cluster = new ArrayList<ArrayList<double[]>>();
		for (int i = 0; i < k; i++) {
			cluster.add(new ArrayList<double[]>());
		}

		return cluster;
	}
	
	// Calculate distance between two points
	private double distance(double[] element, double[] center) {
		double distance = 0.0f;
		double x = element[0] - center[0];
		double y = element[1] - center[1];
		double z = x*x+y*y;
		distance = (double)Math.sqrt(z);
		
		return distance;
	}
	
	// find minimum distance
	private int minDistance(double[] distance) {
		double minDistance = distance[0];
		int minLocation = 0;
		for(int i=1;i<distance.length;i++) {
			if(distance[i] < minDistance) {
				minDistance = distance[i];
				minLocation = i;
			}else if(distance[i]==minDistance) {
				if(random.nextInt(10) < 5) {
					minLocation = i;
				}
			}
		}
		return minLocation;
	}
	
	// core, put element into min-distance center related cluster
	private void clusterSet() {
		double[] distance = new double[k];
		for(int i=0;i<dataSetLength;i++) {
			for(int j=0;j<k;j++) {
				distance[j] = distance(dataSet.get(i), center.get(j));
			}
			int minLocation = minDistance(distance);
			cluster.get(minLocation).add(dataSet.get(i));
		}
	}
	
	// error square
	private double errorSquare(double[] element, double[] center) {
		double x = element[0] - center[0];
		double y = element[1] - center[1];
		
		double errSquare = x*x + y*y;
		
		return errSquare;
	}
	
	// err square overall
	private void countRule() {
		double jcF = 0;
		for(int i=0;i<cluster.size();i++) {
			for(int j=0;j<cluster.get(i).size();j++) {
				jcF += errorSquare(cluster.get(i).get(j), center.get(i));
			}
		}
		jc.add(jcF);
	}
	
	// set new cluster center
	private void setNewCenter() {
		for(int i=0;i<k;i++) {
			int n = cluster.get(i).size();
			if(n!=0) {
				double[] newCenter = {0,0};
				for(int j=0;j<n;j++) {
					newCenter[0]+=cluster.get(i).get(j)[0];
					newCenter[1]+=cluster.get(i).get(j)[1];
				}
				// set an average
				newCenter[0]=newCenter[0]/n;
				newCenter[1]=newCenter[1]/n;
				center.set(i,newCenter);
			}
		}
	}
	
	// print data for test
	public void printDataArray(ArrayList<double[]> dataArray, String dataArrayName) {
		for(int i=0;i<dataArray.size();i++) {
			System.out.println("print:"+dataArrayName+"["+i+"]={"
					+dataArray.get(i)[0]+","+dataArray.get(i)[1]+"}");
		}
		System.out.println("============================");
	}
	
	private void kmeans() {
		init();
		
		// loop dataset, until error rate still
		while(true) {
			clusterSet();
			
			countRule();
			
			if(m!=0) {
				if(jc.get(m)-jc.get(m-1)==0) {
					break;
				}
			}
			
			setNewCenter();
			m++;
			cluster.clear();
			cluster = initCluster();
		}
	}
	
	// Execute KMeans
	public void execute() {
		long startTime = System.currentTimeMillis();
		System.out.println("kmeans begins");
		kmeans();
		long endTime = System.currentTimeMillis();
		System.out.println("kmeans running time="+(endTime-startTime)+"ms");
		System.out.println("kmeans ends");
		System.out.println();
		
	}
}
