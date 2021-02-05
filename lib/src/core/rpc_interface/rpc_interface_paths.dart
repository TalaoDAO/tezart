import 'package:meta/meta.dart';

final pendingOperations = (String chain) => 'chains/$chain/mempool/pending_operations';
final branch = ({ @required String chain,  @required String level}) => 'chains/$chain/blocks/$level/hash';
final chainId = (String chain) => 'chains/$chain/chain_id';

final counter = ({ @required String chain, @required String level, @required String source }) =>
    'chains/$chain/blocks/$level/context/contracts/$source/counter';

final protocol = ({ @required String chain, @required String level }) => 'chains/$chain/blocks/$level/metadata';

final forgeOperations = ({ @required String chain,  @required String level}) =>
    'chains/$chain/blocks/$level/helpers/forge/operations';

final runOperations = ({ @required String chain, @required String level }) =>
    'chains/$chain/blocks/$level/helpers/scripts/run_operation';

final injectOperation = (String chain) => 'injection/operation?chain=$chain';