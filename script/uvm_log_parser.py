

import re
import os

def parse_uvm_log(log_file_path):
    errors = []
    warnings = []
    info_messages = []
    
    if not os.path.exists(log_file_path):
        print(f"Error: Log file not found at {log_file_path}")
        return

    with open(log_file_path, 'r', encoding='utf-8', errors='ignore') as f:
        for line_num, line in enumerate(f, 1):
            # UVM_ERROR pattern
            error_match = re.search(r'UVM_ERROR\s*@\s*(\d+):\s*([^\u005b]+)\[([^\]]+)\]\s*(.*)', line)
            if error_match:
                errors.append({
                    'line_num': line_num,
                    'time': error_match.group(1),
                    'id': error_match.group(3).strip(),
                    'message': error_match.group(4).strip()
                })
                continue

            # UVM_WARNING pattern
            warning_match = re.search(r'UVM_WARNING\s*@\s*(\d+):\s*([^\u005b]+)\[([^\]]+)\]\s*(.*)', line)
            if warning_match:
                warnings.append({
                    'line_num': line_num,
                    'time': warning_match.group(1),
                    'id': warning_match.group(3).strip(),
                    'message': warning_match.group(4).strip()
                })
                continue
            
            # UVM_INFO pattern (optional, for general info)
            info_match = re.search(r'UVM_INFO\s*@\s*(\d+):\s*([^\u005b]+)\[([^\]]+)\]\s*(.*)', line)
            if info_match:
                info_messages.append({
                    'line_num': line_num,
                    'time': info_match.group(1),
                    'id': info_match.group(3).strip(),
                    'message': info_match.group(4).strip()
                })
                continue

    return {
        'errors': errors,
        'warnings': warnings,
        'info': info_messages
    }

def print_results(results):
    if not results:
        return

    print("\n--- UVM Log Analysis Results ---")

    if results['errors']:
        print("\n### ERRORS ###")
        for err in results['errors']:
            print(f"  [Line {err['line_num']}] Time: {err['time']}ps, ID: {err['id']}, Message: {err['message']}")
    else:
        print("\n### No ERRORS found. ###")

    if results['warnings']:
        print("\n### WARNINGS ###")
        for warn in results['warnings']:
            print(f"  [Line {warn['line_num']}] Time: {warn['time']}ps, ID: {warn['id']}, Message: {warn['message']}")
    else:
        print("\n### No WARNINGS found. ###")
    
    # Optionally print some info messages, or filter them
    # if results['info']:
    #     print("\n### INFO Messages (first 10) ###")
    #     for i, info in enumerate(results['info'][:10]):
    #         print(f"  [Line {info['line_num']}] Time: {info['time']}ps, ID: {info['id']}, Message: {info['message']}")


if __name__ == "__main__":
    # This script expects the log file path as a command-line argument
    # Example usage: python uvm_log_parser.py ../log/xsim_apb_dut.log
    import sys
    if len(sys.argv) < 2:
        print("Usage: python uvm_log_parser.py <path_to_uvm_log_file>")
        sys.exit(1)
    
    log_file = sys.argv[1]
    parsed_data = parse_uvm_log(log_file)
    print_results(parsed_data)

