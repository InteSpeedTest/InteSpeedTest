package SpeedtestHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SpeedtestFilter extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		//ArrayList<Double> speedList = (ArrayList<Double>) request.getSession().getAttribute("speedList");
		
		double totalSize = 14.23*4;
		double totalTime = Double.parseDouble(request.getParameter("totalTime"));
		totalTime = Math.round(totalTime * 1000.0) / 1000.0;
		double averageSpeed = 0;
		if(totalTime!=0) {
			averageSpeed = totalSize / totalTime;
			averageSpeed = Math.round(averageSpeed * 1000.0) / 1000.0;
		}
		HttpSession session = request.getSession();
		session.setAttribute("totalTime", totalTime);
		//session.setAttribute("averageSpeed", averageSpeed);
		System.out.println(totalTime);
		
		// Calculate Filtered Average Speed
		String val = request.getParameter("arrayData");
		String aa[] = val.split(",");
		double speedList[] = new double[aa.length];
		double sum1 = 0;
		double topSpeed = 0;
		
		//System.out.println();
		//System.out.print("Array Data: ");
		for(int i=0;i<aa.length;i++) {
			speedList[i] = Double.parseDouble(aa[i]);
			//System.out.print(speedList[i]+",");
			if(speedList[i]>topSpeed) {
				topSpeed = speedList[i];
			}
			sum1 += speedList[i];
		}
		
		double filteredAverage = sum1/aa.length;
		filteredAverage = Math.round(filteredAverage * 1000.0) / 1000.0;
		topSpeed = Math.round(topSpeed * 1000.0) / 1000.0;
		session.setAttribute("filteredAverage", filteredAverage);
		session.setAttribute("topSpeed", topSpeed);
		
		// SpeedList as raw data list
		double minimumVariance = 99999;
		double finalAverage = 0;
		int finalPart = 0;
		
		for (int part = 1; part <= 10; part++) {
			KMeansSample.KMeans k = new KMeansSample.KMeans(part);
			ArrayList<double[]> dataSet = new ArrayList<double[]>();

			for (int i = 0; i < speedList.length; i++) {
				dataSet.add(new double[] { i, speedList[i] });
			}

			k.setDataSet(dataSet);
			k.execute();
			ArrayList<ArrayList<double[]>> cluster = k.getCluster();
			
			// find minimum variance
			double minVariance = 99999;
			int minIndex = 0;
			for (int i = 0; i < cluster.size(); i++) {
				double variance = calculateVariance(cluster.get(i));
				if (variance < minVariance) {
					minVariance = variance;
					minIndex = i;
				}
			}
			//System.out.println(part+ " clusters.");
			//System.out.println("Cluster " + (minIndex + 1) + ": " + minVariance);
			double sum = 0;
			for (int i = 0; i < cluster.get(minIndex).size(); i++) {
				sum += cluster.get(minIndex).get(i)[1];
			}
			//System.out.println("Average Speed:" + (sum / cluster.get(minIndex).size()));
			if(minVariance < minimumVariance) {
				minimumVariance = minVariance;
				finalAverage = sum / cluster.get(minIndex).size();
				finalPart = part;
			}
		}
		
		finalAverage = Math.round(finalAverage * 1000.0) / 1000.0;
		
		System.out.println("\n\n\n Final Result: ");
		System.out.println("Part "+finalPart);
		System.out.println("Variance: "+minimumVariance);
		System.out.println("Average Speed£º "+finalAverage+" MB/s");
		
		session.setAttribute("finalAverage", finalAverage);
		Random r1 = new Random();
		double d1 = r1.nextDouble()*0.05+0.9;
		averageSpeed = Math.round(finalAverage*d1*1000.0)/1000.0;
		session.setAttribute("averageSpeed", averageSpeed);

		
		// Ping Utility
		/*
		String localAddr = request.getLocalAddr();
		String remoteAddr = request.getRemoteAddr();
		String forwardAddr = request.getHeader("X_FORWARDED_FOR");
		session.setAttribute("localAddr", localAddr);
		session.setAttribute("remoteAddr", remoteAddr);
		session.setAttribute("forwardAddr", forwardAddr);
		*/
		
		//String serverIP = request.getLocalAddr();
		double pingTime = 0;
		
		double pingTime1 = 9999;
		double pingTime2 = 9999;
		double pingTime3 = 9999;
		try{
			pingTime1 = Double.parseDouble(request.getParameter("pingTime1"));
		}catch(Exception e){
			System.out.println(e);
		}
		try{
			pingTime2 = Double.parseDouble(request.getParameter("pingTime2"));
		}catch(Exception e){
			System.out.println(e);
		}try{
			pingTime3 = Double.parseDouble(request.getParameter("pingTime3"));
		}catch(Exception e){
			System.out.println(e);
		}
		
		pingTime = Math.min(pingTime1, Math.min(pingTime2, pingTime3));
		pingTime = Math.round(pingTime/3 * 1000.0) / 1000.0;
		session.setAttribute("pingTime", pingTime);
		session.setAttribute("OverallSpeed", speedList);
		
		response.sendRedirect("result.jsp");
	}
	
	private static double calculateVariance(ArrayList<double[]> marks) {
		double variance = 0;
		ArrayList<Double> test = new ArrayList<Double>();
		for (int i = 0; i < marks.size(); i++) {
			test.add(marks.get(i)[1]);
		}
		double avg = calculateAverage(test);
		for (int i = 0; i < marks.size(); i++) {
			variance += Math.pow(marks.get(i)[1] - avg, 2);
		}

		return variance;
	}

	private static double calculateAverage(ArrayList<Double> marks) {
		double sum = 0;
		for (int i = 0; i < marks.size(); i++) {
			// System.out.println(marks.get(i));
			sum += marks.get(i);
		}
		System.out.println(sum + " : " + marks.size());
		return sum / marks.size();
	}
	
	/*
	// Ping time test
	public static double pingUtility(String serverIP) {
		double pingTime = 0;
		serverIP = "58.205.208.77";

		System.out.println("Sending Ping Request to " + serverIP);

		try {
			InetAddress inet = InetAddress.getByName(serverIP);

			long finish = 0;
			long start = new GregorianCalendar().getTimeInMillis();
			if (inet.isReachable(5000)) {
				finish = new GregorianCalendar().getTimeInMillis();
				System.out.println("Ping RTT: " + (finish - start + "ms"));
				pingTime = finish - start;
			} else {
				System.out.println(serverIP + " NOT reachable.");
			}
		} catch (Exception e) {
			System.out.println("Exception" + e.getMessage());
		}

		return pingTime;
	}
	*/
}
