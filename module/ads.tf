resource "random_integer" "ads" {
    min = 0
    max = 2
    keepers = {
        ads_num = var.number_of_nodes
    }
}