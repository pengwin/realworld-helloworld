from diagrams import Diagram, Edge
from diagrams.programming.language import Csharp
from diagrams.generic.device import Mobile
from diagrams.onprem.container import Docker

from diagrams.k8s.network import Ingress
from diagrams.k8s.network import Service
from diagrams.k8s.compute import Pod

with Diagram("Iteration-1", show=False, outformat="png", filename="/output/iteration-1"):
    user = Mobile("User")
    app = Csharp("HelloWorld")

    user >> app

with Diagram("Iteration0", show=False, outformat="png", filename="/output/iteration0"):
    user = Mobile("User")
    app = Csharp("HelloWorld")
    container = Docker("Container")

    user >> container >> app

with Diagram("Iteration1", show=False, outformat="png", filename="/output/iteration1"):
    user = Mobile("User")
    hello_app = Csharp("HelloWorld")
    hello_container = Docker("HelloWorld Container")
    json_app = Csharp("HelloJsonWorld")
    json_container = Docker("HelloJsonWorld Container")

    user >> json_container >> json_app >> hello_container >> hello_app

with Diagram("Iteration2", show=False, outformat="png", filename="/output/iteration2"):
    user = Mobile("User")
    hello_app = Csharp("HelloWorld")
    hello_container = Docker("HelloWorld Container")
    proto_app = Csharp("HelloProtoWorld")
    proto_container = Docker("HelloProtoWorld Container")

    user >> Edge(label = "grpc") >> proto_container >> proto_app >> hello_container >> hello_app

with Diagram("Iteration3", show=False, outformat="png", filename="/output/iteration3"):
    user = Mobile("User")
    hello_app = Csharp("HelloWorld")
    hello_container = Docker("HelloWorld Container")
    proto_app = Csharp("HelloProtoWorld")
    proto_container = Docker("HelloProtoWorld Container")

    ingress = Ingress("Ingress")
    hello_service = Service("HelloWorld Service")
    hello_pod = Pod("HelloWorld Pod")
    
    proto_service = Service("HelloProtoWorld Service")
    proto_pod = Pod("HelloProtoWorld Pod")

    user >> Edge(label = "grpc") >> ingress >> proto_service >> proto_pod >> proto_container
    proto_container >> proto_app >> hello_service
    hello_service >> hello_pod >> hello_container >> hello_app

graph_attr = {
    "splines": "curved"
}

with Diagram("Iteration3-1", show=False, outformat="png", filename="/output/iteration3-1", graph_attr=graph_attr):
    user = Mobile("User")

    ingress = Ingress("Ingress")

    hello_service = Service("HelloWorld Service")
    hello_pod_1 = Pod("HelloWorld Pod1")
    hello_app_1 = Csharp("HelloWorld1")
    hello_container_1 = Docker("HelloWorld1 Container")
    hello_pod_2 = Pod("HelloWorld Pod2")
    hello_app_2 = Csharp("HelloWorld2")
    hello_container_2 = Docker("HelloWorld2 Container")
    hello_pod_3 = Pod("HelloWorld Pod3")
    hello_app_3 = Csharp("HelloWorld3")
    hello_container_3 = Docker("HelloWorld3 Container")

    proto_service = Service("HelloProtoWorld Service")
    proto_pod_1 = Pod("HelloProtoWorld1 Pod")
    proto_app_1 = Csharp("HelloProtoWorld1")
    proto_container_1 = Docker("HelloProtoWorld1 Container")
    proto_pod_2 = Pod("HelloProtoWorld2 Pod")
    proto_app_2 = Csharp("HelloProtoWorld2")
    proto_container_2 = Docker("HelloProtoWorld2 Container")
    proto_pod_3 = Pod("HelloProtoWorld3 Pod")
    proto_app_3 = Csharp("HelloProtoWorld3")
    proto_container_3 = Docker("HelloProtoWorld3 Container")

    hello_pod_1 >> hello_container_1 >> hello_app_1
    hello_pod_2 >> hello_container_2 >> hello_app_2
    hello_pod_3 >> hello_container_3 >> hello_app_3

    hello_service >> [hello_pod_1, hello_pod_2, hello_pod_3]

    proto_pod_1 >> proto_container_1 >> proto_app_1 >> hello_service
    proto_pod_2 >> proto_container_2 >> proto_app_2 >> hello_service
    proto_pod_3 >> proto_container_3 >> proto_app_3 >> hello_service

    proto_service >> [proto_pod_1, proto_pod_2, proto_pod_3]

    user >> Edge(label = "grpc") >> ingress >> proto_service