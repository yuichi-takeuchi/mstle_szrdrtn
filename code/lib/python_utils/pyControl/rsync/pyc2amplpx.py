# -*- coding: utf-8 -*-
"""
Copyright (C) 2020 Yuichi Takeuchi
"""


def actv_gonogo_block_2v0(filenamebase):
    '''
    input:
        pyControl.txt
        rsync timestamp data at 1kHz from matlab (.mat)
    output:
        ephys-tsp-aligned.hdf file for matlab
    '''
    # input files
    pycontrol_datafilename = '../data/' + filenamebase + '.txt'
    ephys_tsp_filename = '../data/' + filenamebase + '_rsync_1k_tsp.mat'
    # output
    aligned_tsp_filename = '../results/' + filenamebase + '.hdf'

    # import standard modules
    import sys
    import numpy as np
    import h5py

    # import helper modules
    sys.path.append('helper/code/tools')
    import data_import as di
    from rsync import Rsync_aligner

    # extract pyControl session data
    session = di.Session(pycontrol_datafilename)

    # get timestamps as np.ndarrays
    tsp_pyc = session.times
    # events
    pulse_times_pycontrol = tsp_pyc['rsync']
    tsp_pk1_in = tsp_pyc['poke1_in']
    tsp_pk1_out = tsp_pyc['poke1_out']
    tsp_pk2_in = tsp_pyc['poke2_in']
    tsp_pk2_out = tsp_pyc['poke2_out']
    tsp_led2_on = tsp_pyc['led2_on']
    tsp_led2_off = tsp_pyc['led2_off']
    tsp_rwrd_on = tsp_pyc['reward_on']
    tsp_rwrd_off = tsp_pyc['reward_off']
    tsp_pnsh_on = tsp_pyc['punish_on']
    tsp_pnsh_off = tsp_pyc['punish_off']
    tsp_if_exit = tsp_pyc['if_exit']
    tsp_sum = tsp_pyc['summarize']
    tsp_btn_prss = tsp_pyc['button_press']
    tsp_end = tsp_pyc['session_end']
    # states
    tsp_iti = tsp_pyc['intertrial_intrvl']
    tsp_pk1 = tsp_pyc['poke1_actv']
    tsp_pk2 = tsp_pyc['poke2_actv']
    tsp_rwrd = tsp_pyc['reward']
    tsp_pnsh = tsp_pyc['punishment']

    # read ephys timestamp (amplipex) via .mat file
    with h5py.File(ephys_tsp_filename, 'r') as f:
        pulse_times_ephys = np.array(f['tsp_pulse_ephys'])

    # synchronize timestamps of pyControl events and states to ephys one
    # instantiate ephys_aligner
    pulse_times_ephys = np.transpose(pulse_times_ephys)
    pulse_times_ephys = pulse_times_ephys[0]
    ephys_aligner = Rsync_aligner(pulse_times_A=pulse_times_pycontrol,
                                  pulse_times_B=pulse_times_ephys)

    # events
    tsp_pk1_in_ephys = ephys_aligner.A_to_B(tsp_pk1_in)
    tsp_pk1_out_ephys = ephys_aligner.A_to_B(tsp_pk1_out)
    tsp_pk2_in_ephys = ephys_aligner.A_to_B(tsp_pk2_in)
    tsp_pk2_out_ephys = ephys_aligner.A_to_B(tsp_pk2_out)
    tsp_led2_on_ephys = ephys_aligner.A_to_B(tsp_led2_on)
    tsp_led2_off_ephys = ephys_aligner.A_to_B(tsp_led2_off)
    tsp_rwrd_on_ephys = ephys_aligner.A_to_B(tsp_rwrd_on)
    tsp_rwrd_off_ephys = ephys_aligner.A_to_B(tsp_rwrd_off)
    tsp_pnsh_on_ephys = ephys_aligner.A_to_B(tsp_pnsh_on)
    tsp_pnsh_off_ephys = ephys_aligner.A_to_B(tsp_pnsh_off)
    tsp_if_exit_ephys = ephys_aligner.A_to_B(tsp_if_exit)
    tsp_sum_ephys = ephys_aligner.A_to_B(tsp_sum)
    tsp_btn_prss_ephys = ephys_aligner.A_to_B(tsp_btn_prss)
    tsp_end_ephys = ephys_aligner.A_to_B(tsp_end)
    # states
    tsp_iti_ephys = ephys_aligner.A_to_B(tsp_iti)
    tsp_pk1_ephys = ephys_aligner.A_to_B(tsp_pk1)
    tsp_pk2_ephys = ephys_aligner.A_to_B(tsp_pk2)
    tsp_rwrd_ephys = ephys_aligner.A_to_B(tsp_rwrd)
    tsp_pnsh_ephys = ephys_aligner.A_to_B(tsp_pnsh)

    # file-output for MATLAB
    with h5py.File(aligned_tsp_filename, 'w') as f:
        f.create_group('event')
        f.create_dataset('event/tsp_pk1_in', data=tsp_pk1_in_ephys)
        f.create_dataset('event/tsp_pk1_out', data=tsp_pk1_out_ephys)
        f.create_dataset('event/tsp_pk2_in', data=tsp_pk2_in_ephys)
        f.create_dataset('event/tsp_pk2_out', data=tsp_pk2_out_ephys)
        f.create_dataset('event/tsp_led2_on', data=tsp_led2_on_ephys)
        f.create_dataset('event/tsp_led2_off', data=tsp_led2_off_ephys)
        f.create_dataset('event/tsp_rwrd_on', data=tsp_rwrd_on_ephys)
        f.create_dataset('event/tsp_rwrd_off', data=tsp_rwrd_off_ephys)
        f.create_dataset('event/tsp_pnsh_on', data=tsp_pnsh_on_ephys)
        f.create_dataset('event/tsp_pnsh_off', data=tsp_pnsh_off_ephys)
        f.create_dataset('event/tsp_if_exit', data=tsp_if_exit_ephys)
        f.create_dataset('event/tsp_sum', data=tsp_sum_ephys)
        f.create_dataset('event/tsp_btn_prss', data=tsp_btn_prss_ephys)
        f.create_dataset('event/tsp_end', data=tsp_end_ephys)
        f.create_group('state')
        f.create_dataset('state/tsp_iti', data=tsp_iti_ephys)
        f.create_dataset('state/tsp_pk1', data=tsp_pk1_ephys)
        f.create_dataset('state/tsp_pk2', data=tsp_pk2_ephys)
        f.create_dataset('state/tsp_rwrd', data=tsp_rwrd_ephys)
        f.create_dataset('state/tsp_pnsh', data=tsp_pnsh_ephys)