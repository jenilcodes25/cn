import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

public class DHCPClient {
    public static void main(String[] args) {
        try {
            DatagramSocket socket = new DatagramSocket();
            socket.setBroadcast(true);
            byte[] discover = "DHCP Discover".getBytes();

            // Send DHCP Discover
            DatagramPacket discoverPacket = new DatagramPacket(discover, discover.length, InetAddress.getByName("255.255.255.255"), 67);
            socket.send(discoverPacket);
            System.out.println("Sent DHCP Discover");

            // Receive DHCP Offer
            byte[] buffer = new byte[1024];
            DatagramPacket offerPacket = new DatagramPacket(buffer, buffer.length);
            socket.receive(offerPacket);

            String offerMessage = new String(offerPacket.getData(), 0, offerPacket.getLength());
            System.out.println("Received: " + offerMessage);

            // Close the socket
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

public class DHCPServer {
    public static void main(String[] args) {
        try {
            DatagramSocket socket = new DatagramSocket(67); // DHCP server port
            byte[] buffer = new byte[1024];

            while (true) {
                DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
                socket.receive(packet); // Receive DHCP Discover

                System.out.println("Received DHCP Discover from: " + packet.getAddress());

                // Prepare a DHCP Offer (simplified)
                byte[] offer = "DHCP Offer: IP=192.168.1.100".getBytes();
                DatagramPacket offerPacket = new DatagramPacket(offer, offer.length, packet.getAddress(), packet.getPort());
                socket.send(offerPacket); // Send DHCP Offer
                System.out.println("Sent DHCP Offer to: " + packet.getAddress());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}