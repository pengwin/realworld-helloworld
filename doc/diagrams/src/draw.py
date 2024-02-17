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