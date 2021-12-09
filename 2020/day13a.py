def main():
    lines = open('input.txt','r').read().splitlines()
    arrival = int(lines[0])
    buses = [int(bus_id) for bus_id in lines[1].split(',') if bus_id != 'x']
    waits = [bus_id - arrival % bus_id for bus_id in buses]
    print(min(waits) * buses[waits.index(min(waits))])
        
if __name__ == '__main__':
    main()